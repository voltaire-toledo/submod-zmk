param(
    [string]$KeymapPath = "JIGS/QC-IN_PROGRESS/v1.2-validator-hardening.keymap",
    [string]$BaselinePath = "JIGS/v1.0-HRM-QC_PASSED.keymap",
    [string]$ExpectedBaselineSha256 = "faa1612fc82c6c23bfa43e1f1551a576a6a3feeaee2bbb0af9d9c3cd219d056d",
    [int[]]$ApprovedKeyPositions = @(),
    [string]$ExpectedCandidateDefinitionsSha256 = ""
)

$ErrorActionPreference = "Stop"
$errors = [System.Collections.Generic.List[string]]::new()

function Add-ValidationError {
    param([string]$Message)
    $errors.Add($Message)
}

function Get-Sha256 {
    param([string]$Path)

    $stream = [System.IO.File]::OpenRead((Resolve-Path -LiteralPath $Path))
    try {
        $algorithm = [System.Security.Cryptography.SHA256]::Create()
        try {
            return ([System.BitConverter]::ToString($algorithm.ComputeHash($stream))).Replace("-", "").ToLowerInvariant()
        }
        finally { $algorithm.Dispose() }
    }
    finally { $stream.Dispose() }
}

function Get-TextSha256 {
    param([string]$Text)

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $algorithm = [System.Security.Cryptography.SHA256]::Create()
    try {
        return ([System.BitConverter]::ToString($algorithm.ComputeHash($bytes))).Replace("-", "").ToLowerInvariant()
    }
    finally { $algorithm.Dispose() }
}

function Get-KeymapLayers {
    param([string]$Path)

    $content = Get-Content -Raw -LiteralPath $Path
    $pattern = '(?ms)^\s*(?<name>default_layer|layer_one|layer_two|layer_three|layer_base|layer_fn_num|layer_sym|layer_nav)\s*\{\s*bindings\s*=\s*<(?<bindings>.*?)>;'
    $layers = @()

    foreach ($match in [regex]::Matches($content, $pattern)) {
        $bindingText = [regex]::Replace($match.Groups['bindings'].Value, '(?m)//.*$', '')
        $entries = @(
            [regex]::Split($bindingText, '(?=&[A-Za-z_][A-Za-z0-9_]*)') |
                ForEach-Object { ($_ -replace '\s+', ' ').Trim() } |
                Where-Object { $_.StartsWith('&') }
        )
        $layers += [PSCustomObject]@{ Name = $match.Groups['name'].Value; Entries = $entries }
    }

    return $layers
}

function Get-DefinitionsText {
    param([string]$Path)

    $content = Get-Content -Raw -LiteralPath $Path
    $keymapStart = [regex]::Match($content, '(?m)^\s*keymap\s*\{')
    if (-not $keymapStart.Success) { throw "No zmk,keymap node was found in $Path." }

    $definitions = $content.Substring(0, $keymapStart.Index)
    $definitions = [regex]::Replace($definitions, '(?ms)/\*.*?\*/', '')
    $definitions = [regex]::Replace($definitions, '(?m)//.*$', '')
    return ($definitions -replace '\s+', ' ').Trim()
}

function Test-ExpectedLayerShape {
    param([object[]]$Layers, [string]$Label)

    if ($Layers.Count -ne 4) {
        Add-ValidationError "$Label has $($Layers.Count) keymap layers; expected 4."
        return
    }

    foreach ($layer in $Layers) {
        if ($layer.Entries.Count -ne 82) {
            Add-ValidationError "$Label layer $($layer.Name) has $($layer.Entries.Count) bindings; expected 82."
        }
    }
}

if ($ApprovedKeyPositions.Count -gt 4) {
    Add-ValidationError "ApprovedKeyPositions allows $($ApprovedKeyPositions.Count) physical positions; revisions may allow at most 4."
}

foreach ($position in $ApprovedKeyPositions) {
    if ($position -lt 0 -or $position -gt 81) {
        Add-ValidationError "ApprovedKeyPositions contains $position; valid physical positions are 0 through 81."
    }
}

if ((@($ApprovedKeyPositions | Select-Object -Unique)).Count -ne $ApprovedKeyPositions.Count) {
    Add-ValidationError "ApprovedKeyPositions contains duplicate physical positions."
}

if (-not (Test-Path -LiteralPath $BaselinePath)) { Add-ValidationError "Baseline keymap does not exist: $BaselinePath" }
if (-not (Test-Path -LiteralPath $KeymapPath)) { Add-ValidationError "Candidate keymap does not exist: $KeymapPath" }

if ($errors.Count -eq 0) {
    $baselineHash = Get-Sha256 $BaselinePath
    if ($baselineHash -ne $ExpectedBaselineSha256) {
        Add-ValidationError "Baseline SHA-256 is $baselineHash; expected immutable HRM baseline $ExpectedBaselineSha256."
    }

    $baselineLayers = @(Get-KeymapLayers $BaselinePath)
    $candidateLayers = @(Get-KeymapLayers $KeymapPath)
    Test-ExpectedLayerShape $baselineLayers "Baseline"
    Test-ExpectedLayerShape $candidateLayers "Candidate"

    $baselineDefinitions = Get-DefinitionsText $BaselinePath
    $candidateDefinitions = Get-DefinitionsText $KeymapPath
    if ($baselineDefinitions -ne $candidateDefinitions) {
        if ([string]::IsNullOrWhiteSpace($ExpectedCandidateDefinitionsSha256)) {
            Add-ValidationError "Behavior definitions, combos, includes, or preprocessor constants differ from the baseline without an approved candidate definitions SHA-256."
        }
        else {
            $candidateDefinitionsHash = Get-TextSha256 $candidateDefinitions
            if ($candidateDefinitionsHash -ne $ExpectedCandidateDefinitionsSha256.ToLowerInvariant()) {
                Add-ValidationError "Candidate definitions SHA-256 is $candidateDefinitionsHash; expected $ExpectedCandidateDefinitionsSha256."
            }
        }
    }

    $changedPositions = [System.Collections.Generic.List[int]]::new()
    if ($baselineLayers.Count -eq 4 -and $candidateLayers.Count -eq 4) {
        for ($layerIndex = 0; $layerIndex -lt 4; $layerIndex++) {
            $baselineLayer = $baselineLayers[$layerIndex]
            $candidateLayer = $candidateLayers[$layerIndex]

            if ($baselineLayer.Name -ne $candidateLayer.Name) {
                Add-ValidationError "Layer $layerIndex is named $($candidateLayer.Name); baseline requires $($baselineLayer.Name)."
            }

            if ($baselineLayer.Entries.Count -eq 82 -and $candidateLayer.Entries.Count -eq 82) {
                for ($position = 0; $position -lt 82; $position++) {
                    if ($baselineLayer.Entries[$position] -ne $candidateLayer.Entries[$position]) {
                        $changedPositions.Add($position)
                    }
                }

                for ($position = 77; $position -le 81; $position++) {
                    if ($baselineLayer.Entries[$position] -ne $candidateLayer.Entries[$position]) {
                        Add-ValidationError "Protected direct-control position $position differs on layer ${layerIndex}: expected '$($baselineLayer.Entries[$position])', found '$($candidateLayer.Entries[$position])'."
                    }
                }
            }
        }
    }

    $changedUnique = @($changedPositions | Select-Object -Unique)
    $unapproved = @($changedUnique | Where-Object { $_ -notin $ApprovedKeyPositions })
    $unusedApprovals = @($ApprovedKeyPositions | Where-Object { $_ -notin $changedUnique })

    if ($unapproved.Count -gt 0) { Add-ValidationError "Candidate changes unapproved physical positions: $($unapproved -join ', ')." }
    if ($unusedApprovals.Count -gt 0) { Add-ValidationError "ApprovedKeyPositions lists unchanged positions: $($unusedApprovals -join ', ')." }
    if ($changedUnique.Count -gt 4) { Add-ValidationError "Candidate changes $($changedUnique.Count) physical positions; revisions may change at most 4." }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}

Write-Output "Keymap validation passed: immutable baseline, 4 layers x 82 bindings, and all 20 direct controls match."
