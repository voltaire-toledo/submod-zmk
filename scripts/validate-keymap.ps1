param(
    [string]$KeymapPath = "app/boards/shields/keychron/b1/us/keychron_b1_us.keymap"
)

$ErrorActionPreference = "Stop"
$content = Get-Content -Raw -LiteralPath $KeymapPath
$errors = [System.Collections.Generic.List[string]]::new()

function Require-Pattern {
    param([string]$Pattern, [string]$Message)
    if ($content -notmatch $Pattern) {
        $errors.Add($Message)
    }
}

Require-Pattern 'lhm:\s*left_homerow_mods\s*\{' "Missing left-hand HRM behavior."
Require-Pattern 'rhm:\s*right_homerow_mods\s*\{' "Missing right-hand HRM behavior."
Require-Pattern 'lhm:\s*left_homerow_mods\s*\{[\s\S]*?hold-trigger-key-positions\s*=\s*<[\s\S]*?47 48 49 50 51 52 53[\s\S]*?70 71 72 73 74 75[\s\S]*?>;' "Left HRMs do not require a right-hand trigger."
Require-Pattern 'rhm:\s*right_homerow_mods\s*\{[\s\S]*?hold-trigger-key-positions\s*=\s*<\s*0 1 2 3 4 5 6[\s\S]*?66 67 68 69[\s\S]*?>;' "Right HRMs do not require a left-hand trigger."
Require-Pattern '&lhm LCTRL A\s+&lhm LGUI S\s+&lhm LALT D\s+&lhm LSHFT F' "Left home row is not bound to the bilateral HRM behavior."
Require-Pattern '&rhm RSHFT J\s+&rhm RALT K\s+&rhm RGUI L\s+&rhm RCTRL SEMI' "Right home row is not bound to the bilateral HRM behavior."
Require-Pattern '&kp LCTRL\s+&uc LCMD\s+&uc LALT\s+&kp SPACE' "Layer 0 left modifiers are not ordered Ctrl, GUI, Alt."
Require-Pattern '&to 0' "No explicit layer-0 escape binding was found."
Require-Pattern 'long_press_bootloader' "Bootloader behavior was not found."

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output "Keymap validation passed: bilateral HRMs, layer escape, and bootloader behavior are present."
