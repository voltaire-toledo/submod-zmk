param(
    [string]$KeymapPath = "B1PRO/releases/0.23-All_MacOS_Layers_defined/v0.23-mac-win-full-layers.keymap",
    [string]$DesignPath = "B1PRO/DESIGN/B1Pro-ZMK-KEYMAP.md",
    [string]$ExpectedCandidateSha256 = "984d7250d8eb08977c4a6de168b69c25edd48376c70d6056b59f936697da7813"
)

$ErrorActionPreference = "Stop"
$errors = [System.Collections.Generic.List[string]]::new()

function Add-ValidationError { param([string]$Message) $errors.Add($Message) }

function Get-Sha256 {
    param([string]$Path)
    $stream = [System.IO.File]::OpenRead((Resolve-Path -LiteralPath $Path))
    try {
        $algorithm = [System.Security.Cryptography.SHA256]::Create()
        try { return ([System.BitConverter]::ToString($algorithm.ComputeHash($stream))).Replace('-', '').ToLowerInvariant() }
        finally { $algorithm.Dispose() }
    }
    finally { $stream.Dispose() }
}

function Get-KeymapLayers {
    param([string]$Path)
    $content = Get-Content -Raw -LiteralPath $Path
    $pattern = '(?ms)^\s*(?<name>[A-Za-z_][A-Za-z0-9_]*)\s*\{\s*bindings\s*=\s*<(?<bindings>.*?)>;'
    foreach ($match in [regex]::Matches($content, $pattern)) {
        $bindingText = [regex]::Replace($match.Groups['bindings'].Value, '(?m)//.*$', '')
        $entries = @(
            [regex]::Split($bindingText, '(?=&[A-Za-z_][A-Za-z0-9_]*)') |
                ForEach-Object { ($_ -replace '\s+', ' ').Trim() } |
                Where-Object { $_.StartsWith('&') }
        )
        [PSCustomObject]@{ Name = $match.Groups['name'].Value; Entries = $entries }
    }
}

function Assert-Binding {
    param([object[]]$Layers, [int]$Layer, [int]$Position, [string]$Expected)
    if ($Layers[$Layer].Entries[$Position] -ne $Expected) {
        Add-ValidationError "Layer $Layer position $Position is '$($Layers[$Layer].Entries[$Position])'; expected '$Expected'."
    }
}

if (-not (Test-Path -LiteralPath $KeymapPath)) { Add-ValidationError "Candidate keymap does not exist: $KeymapPath" }
if (-not (Test-Path -LiteralPath $DesignPath)) { Add-ValidationError "Design source of truth does not exist: $DesignPath" }
if ($errors.Count -eq 0 -and (Get-Sha256 $KeymapPath) -ne $ExpectedCandidateSha256) {
    Add-ValidationError "Candidate SHA-256 does not match the reviewed v0.23 release identity."
}

if ($errors.Count -eq 0) {
    $candidate = @(Get-KeymapLayers $KeymapPath)
    $expectedNames = @(
        'layer_m_base', 'layer_m_func', 'layer_m_sym1', 'layer_m_nav1', 'layer_m_uat', 'layer_m_mcro',
        'layer_w_base', 'layer_w_func', 'layer_w_sym1', 'layer_w_nav1', 'layer_w_uat', 'layer_w_mcro'
    )
    if ($candidate.Count -ne 12) { Add-ValidationError "Candidate has $($candidate.Count) layers; expected 12 (Mac 0--5, Windows 6--11)." }
    foreach ($layer in $candidate) {
        if ($layer.Entries.Count -ne 82) { Add-ValidationError "Layer $($layer.Name) has $($layer.Entries.Count) bindings; expected 82." }
    }
    if ($candidate.Count -eq 12) {
        for ($index = 0; $index -lt $expectedNames.Count; $index++) {
            if ($candidate[$index].Name -ne $expectedNames[$index]) {
                Add-ValidationError "Layer $index is '$($candidate[$index].Name)'; expected '$($expectedNames[$index])'."
            }
        }

        # Both OS bases and all direct controls are explicit; none may be inferred.
        Assert-Binding $candidate 0 0 '&esc_caps CLCK ESC'
        Assert-Binding $candidate 0 77 '&mo LYR_W_BASE'
        Assert-Binding $candidate 6 0 '&esc_caps CLCK ESC'
        foreach ($layer in 6..11) { foreach ($position in 77..81) { Assert-Binding $candidate $layer $position '&none' } }

        # Fn selectors: Mac one-shot selects Layer 5; Windows one-shot selects Layer 11.
        Assert-Binding $candidate 0 72 '&fn_layer_access LYR_M_FUNC LYR_M_MCRO'
        Assert-Binding $candidate 6 72 '&fn_layer_access LYR_W_FUNC LYR_W_MCRO'
        Assert-Binding $candidate 5 0 '&to LYR_M_BASE'
        Assert-Binding $candidate 11 0 '&to LYR_W_BASE'
        foreach ($item in @(@(5, 15, '&to LYR_M_FUNC'), @(5, 16, '&to LYR_M_SYM1'), @(5, 17, '&to LYR_M_NAV1'), @(5, 18, '&to LYR_M_UAT'), @(11, 15, '&to LYR_W_FUNC'), @(11, 16, '&to LYR_W_SYM1'), @(11, 17, '&to LYR_W_NAV1'), @(11, 18, '&to LYR_W_UAT'))) {
            Assert-Binding $candidate $item[0] $item[1] $item[2]
        }
        foreach ($layer in @(4, 10)) {
            for ($position = 1; $position -lt 82; $position++) { Assert-Binding $candidate $layer $position '&none' }
        }
        foreach ($layer in @(5, 11)) {
            foreach ($position in @(1..14 + 19..81)) { Assert-Binding $candidate $layer $position '&none' }
        }

        # F6 and the diagram-resolved symbol/nav positions must agree on both OS families.
        Assert-Binding $candidate 1 6 '&uc LC(LA(M))'
        Assert-Binding $candidate 7 6 '&uc LC(LA(M))'
        foreach ($layer in @(2, 8)) {
            Assert-Binding $candidate $layer 37 '&td_sym_minus_underscore 0'
            Assert-Binding $candidate $layer 38 '&td_sym_equal_plus 0'
            Assert-Binding $candidate $layer 40 '&trans'
        }
        foreach ($item in @(@(3, 56, '&uc LG(Z)'), @(3, 57, '&uc LG(X)'), @(3, 58, '&uc LG(C)'), @(3, 59, '&uc LG(V)'), @(3, 60, '&uc LG(B)'), @(9, 56, '&uc LC(Z)'), @(9, 57, '&uc LC(X)'), @(9, 58, '&uc LC(C)'), @(9, 59, '&uc LC(V)'), @(9, 60, '&uc LC(B)'))) {
            Assert-Binding $candidate $item[0] $item[1] $item[2]
        }
        Assert-Binding $candidate 3 22 '&kp SPACE'
        Assert-Binding $candidate 9 22 '&kp SPACE'

        $content = Get-Content -Raw -LiteralPath $KeymapPath
        foreach ($forbidden in @('&td ?????', '&ktrans', '?????')) {
            if ($content.Contains($forbidden)) { Add-ValidationError "Unresolved placeholder remains: $forbidden" }
        }
        foreach ($required in @('label = "ESC_CAPS_LOCK";', 'label = "FN_LAYER_ACCESS";', 'label = "TD_SYM_MINUS_UNDERSCORE";', 'label = "TD_SYM_EQUAL_PLUS";', '/* WINDOWS LAYER 7:', '/* WINDOWS LAYER 11:')) {
            if (-not $content.Contains($required)) { Add-ValidationError "Required v0.23 behavior or physical illustration is missing: $required" }
        }
        if ($content -notmatch '(?s)esc_caps:\s*escape_caps_lock\s*\{.*?tapping-term-ms\s*=\s*<600>;.*?bindings\s*=\s*<&kp>,\s*<&kp>;') {
            Add-ValidationError 'Esc hold-to-Caps behavior must issue ordinary key press/release bindings after 600 ms.'
        }
        if ($content -notmatch '(?s)fn_layer_access:\s*fn_layer_access\s*\{.*?tapping-term-ms\s*=\s*<200>;.*?bindings\s*=\s*<&mo>,\s*<&sl>;') {
            Add-ValidationError 'Fn one-shot/momentary hold-tap definition is incomplete.'
        }
        $design = Get-Content -Raw -LiteralPath $DesignPath
        foreach ($required in @('### Layer Index 6: Windows Base `LYR_W_BASE`', '### Windows Layer 7: `LYR_W_FUNC`', 'layer_w_sym1 {', 'layer_w_nav1 {', 'layer_w_uat {', 'layer_w_mcro {', '&uc LC(LA(M))', '&td_sym_minus_underscore 0', '&td_sym_equal_plus 0', '&uc LC(V)')) {
            if (-not $design.Contains($required)) { Add-ValidationError "Design illustration/specification is missing its v0.23 source-of-truth anchor: $required" }
        }
        foreach ($forbidden in @('&td ?????', '&ktrans', '?????')) {
            if ($design.Contains($forbidden)) { Add-ValidationError "Design illustration/specification still contains an unresolved placeholder: $forbidden" }
        }
        $designLayers = @(Get-KeymapLayers $DesignPath)
        for ($index = 0; $index -lt $expectedNames.Count; $index++) {
            $designLayer = @($designLayers | Where-Object { $_.Name -eq $expectedNames[$index] })
            if ($designLayer.Count -ne 1) {
                Add-ValidationError "Design must contain exactly one executable binding block for $($expectedNames[$index]); found $($designLayer.Count)."
                continue
            }
            if ($designLayer[0].Entries.Count -ne 82) {
                Add-ValidationError "Design binding block $($expectedNames[$index]) has $($designLayer[0].Entries.Count) bindings; expected 82."
                continue
            }
            foreach ($position in 0..81) {
                if ($candidate[$index].Entries[$position] -ne $designLayer[0].Entries[$position]) {
                    Add-ValidationError "Diagram/code mismatch: $($expectedNames[$index]) position $position is '$($designLayer[0].Entries[$position])' in the design but '$($candidate[$index].Entries[$position])' in the candidate."
                }
            }
        }
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}

Write-Output 'v0.23 validation passed: 12 illustrated 82-binding layers, exact Mac/Windows selectors, diagram-to-code anchors, resolved symbol and navigation positions, inert direct controls, and single-hold Esc Caps behavior.'
