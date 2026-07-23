param(
    [string]$KeymapPath = "JIGS/QC-IN_PROGRESS/v0.19-ten-key-foundation.keymap",
    [string]$BaselinePath = "JIGS/QC-PASS/v0.9-Esc-Hold-to-Toggle-CapsLock/v0.9-esc-caps.keymap",
    [string]$ExpectedBaselineSha256 = "abbbf227ae1ffcb1d164775673fd1bfe2338b07c6b7ebf01e1f686838091a187",
    [int[]]$ApprovedKeyPositions = @(0, 15, 16, 17, 29, 30, 31, 41, 42, 47, 72),
    [string]$ExpectedCandidateDefinitionsSha256 = "cfea801c1411b07433aed2b2a3b7f5f1b564c7e33454805a08084ae0987367f0"
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
    $pattern = '(?ms)^\s*(?<name>default_layer|layer_one|layer_two|layer_three|layer_four_reserved|layer_selector|layer_base|layer_fn_num|layer_sym|layer_nav)\s*\{\s*bindings\s*=\s*<(?<bindings>.*?)>;'
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
    param([object[]]$Layers, [string]$Label, [int]$ExpectedCount)

    if ($Layers.Count -ne $ExpectedCount) {
        Add-ValidationError "$Label has $($Layers.Count) keymap layers; expected $ExpectedCount."
        return
    }

    foreach ($layer in $Layers) {
        if ($layer.Entries.Count -ne 82) {
            Add-ValidationError "$Label layer $($layer.Name) has $($layer.Entries.Count) bindings; expected 82."
        }
    }
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
    Test-ExpectedLayerShape $baselineLayers "Baseline" 4
    Test-ExpectedLayerShape $candidateLayers "Candidate" 6

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
    if ($baselineLayers.Count -eq 4 -and $candidateLayers.Count -eq 6) {
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

        $reserved = $candidateLayers[4]
        if ($reserved.Name -ne 'layer_four_reserved') {
            Add-ValidationError "Candidate layer 4 is named $($reserved.Name); expected layer_four_reserved."
        }

        if ($reserved.Entries.Count -eq 82) {
            for ($position = 0; $position -lt 82; $position++) {
                $expected = if ($position -ge 77) { '&none' } else { '&trans' }
                if ($reserved.Entries[$position] -ne $expected) {
                    Add-ValidationError "Reserved layer 4 position $position is '$($reserved.Entries[$position])'; expected '$expected'."
                }
            }
        }

        $selector = $candidateLayers[5]
        if ($selector.Name -ne 'layer_selector') {
            Add-ValidationError "Candidate layer 5 is named $($selector.Name); expected layer_selector."
        }

        if ($selector.Entries.Count -eq 82) {
            for ($position = 0; $position -lt 82; $position++) {
                $expected = if ($position -eq 15) {
                    '&to 1'
                }
                elseif ($position -eq 16) {
                    '&to 2'
                }
                elseif ($position -eq 17) {
                    '&to 3'
                }
                elseif ($position -ge 77) {
                    '&none'
                }
                else {
                    '&trans'
                }

                if ($selector.Entries[$position] -ne $expected) {
                    Add-ValidationError "Selector layer position $position is '$($selector.Entries[$position])'; expected '$expected'."
                }
            }

            $changedPositions.Add(15)
            $changedPositions.Add(16)
            $changedPositions.Add(17)
        }
    }

    $changedUnique = @($changedPositions | Select-Object -Unique)
    $unapproved = @($changedUnique | Where-Object { $_ -notin $ApprovedKeyPositions })
    $unusedApprovals = @($ApprovedKeyPositions | Where-Object { $_ -notin $changedUnique })

    if ($unapproved.Count -gt 0) { Add-ValidationError "Candidate changes unapproved physical positions: $($unapproved -join ', ')." }
    if ($unusedApprovals.Count -gt 0) { Add-ValidationError "ApprovedKeyPositions lists unchanged positions: $($unusedApprovals -join ', ')." }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}

Write-Output "Keymap validation passed: immutable 4-layer baseline, 6-layer candidate, 82 bindings per layer, and all 30 candidate direct controls match."
