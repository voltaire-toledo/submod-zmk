# Keychron B1 Pro ZMK Build Guide (Windows + WSL)

This guide is for a human preparing and building this repository shortly after
editing a `.keymap` file. It starts with a Windows PC that has only Visual
Studio Code and WSL available.

Build inside WSL's Linux filesystem. Do **not** build under `/mnt/c` or another
mounted Windows drive: performance and Linux file permissions are more reliable
under the Linux home directory. Use Windows only to copy the finished UF2 to
the keyboard's bootloader drive.

## What this repository requires

This is Keychron's B Pro ZMK fork, not current upstream ZMK. Keep these pinned
versions together:

- Firmware source: `https://github.com/Keychron/zmk.git`, branch
  `keychron_bpro` (or this project's own remote/branch).
- Zephyr revision: `v3.2.0+zmk-fixes`, defined by `app/west.yml`.
- Zephyr SDK: **0.15.2** with the `arm-zephyr-eabi` toolchain.
- Target: board `keychron`; shield `keychron_b1_us`.
- Output: `build/<name>/zephyr/zmk.uf2`.

The supplied `.devcontainer` also pins a ZMK 3.2 image, but it needs Docker.
This guide deliberately uses native WSL because Docker is not assumed.

## 1. Install a Linux distribution and VS Code's WSL support

Open **Windows PowerShell as Administrator**. If an Ubuntu distribution is not
already installed, run:

```powershell
wsl --install -d Ubuntu-24.04
```

Restart when Windows requests it, launch Ubuntu from the Start menu, and create
your Linux username and password. Then install VS Code's Remote - WSL extension
from the Extensions panel, or run:

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

Open the Ubuntu terminal. All commands through the build section below run
there, not in Windows PowerShell.

## 2. Install WSL host dependencies

In Ubuntu:

```bash
sudo apt update
sudo apt install --yes \
  git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget \
  python3-dev python3-venv python3-tk xz-utils file make gcc gcc-multilib \
  g++-multilib libsdl2-dev libmagic1

cmake --version
python3 --version
dtc --version
```

The package set follows Zephyr's Ubuntu host-dependency guidance. A WSL build
is appropriate here; use Windows for the final keyboard flash rather than
trying to access the bootloader directly from WSL.

## 3. Clone or open the repository

Keep the checkout inside the Linux home directory. For a fresh vendor checkout:

```bash
mkdir -p ~/src
cd ~/src
git clone --branch keychron_bpro https://github.com/Keychron/zmk.git VT-Mello-Keymaps-ZMK
cd VT-Mello-Keymaps-ZMK
```

If this project is hosted in another remote, clone that remote instead. Do not
overwrite an existing checkout that contains uncommitted keymap work.

Open it in VS Code's WSL context:

```bash
code .
```

## 4. Initialize the West workspace and Python environment

Run once for a new checkout:

```bash
cd ~/src/VT-Mello-Keymaps-ZMK

python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
python -m pip install west

west init -l app
west update
python -m pip install -r zephyr/scripts/requirements.txt
```

`west update` downloads Zephyr and the modules named by `app/west.yml`. It can
take several minutes and several gigabytes of disk space.

### Apply Keychron's Zephyr patch

This repository includes `0001-esb-nrf-fix.patch`. Apply it exactly once to a
fresh Zephyr dependency checkout:

```bash
git -C zephyr am ../0001-esb-nrf-fix.patch
```

If that command says the patch is already applied or does not apply, stop. Do
not force it. Check the dependency state first:

```bash
git -C zephyr status --short
git -C zephyr log --oneline --all --grep='esb nrf fix'
```

If an attempted `git am` is in progress and must be abandoned, use:

```bash
git -C zephyr am --abort
```

## 5. Install the matching Zephyr SDK

Download the **Linux x86-64 full** Zephyr SDK 0.15.2 bundle from the
[`v0.15.2` Zephyr SDK release](https://github.com/zephyrproject-rtos/sdk-ng/releases/tag/v0.15.2).
The direct asset URL is:

```text
https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.2/zephyr-sdk-0.15.2_linux-x86_64.tar.gz
```

In Ubuntu:

```bash
cd ~
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.2/zephyr-sdk-0.15.2_linux-x86_64.tar.gz
tar xvf zephyr-sdk-0.15.2_linux-x86_64.tar.gz
cd zephyr-sdk-0.15.2
./setup.sh
```

After setup completes, configure this shell to use it:

```bash
export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
export ZEPHYR_SDK_INSTALL_DIR="$HOME/zephyr-sdk-0.15.2"
```

To make those settings available in future Ubuntu terminals, append the same
two `export` lines to `~/.bashrc`, then open a new terminal.

## 6. Edit and inspect the keymap

The active B1 Pro ANSI keymap is:

```text
app/boards/shields/keychron/b1/us/keychron_b1_us.keymap
```

After editing, review only the intended changes before building:

```bash
git diff --check -- app/boards/shields/keychron/b1/us/keychron_b1_us.keymap
git diff -- app/boards/shields/keychron/b1/us/keychron_b1_us.keymap
```

For this project's current four-layer design, also run the focused contract
validator from the repository root:

```bash
source .venv/bin/activate
pwsh -NoProfile -File scripts/validate-keymap.ps1
```

If PowerShell 7 (`pwsh`) is not installed in WSL, run that validator later in
Windows PowerShell from the Windows checkout, or install PowerShell 7 for WSL.
The firmware build itself does not require PowerShell.

## 7. Perform a pristine B1 Pro build

From the repository root in Ubuntu, activate the virtual environment and set
the SDK variables if they are not already in your shell:

```bash
source .venv/bin/activate
export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
export ZEPHYR_SDK_INSTALL_DIR="$HOME/zephyr-sdk-0.15.2"
```

Use a unique build directory for each candidate image. This avoids stale CMake
configuration and preserves the prior artifact for comparison. Replace
`layers-0-3-r1` with the revision candidate you are building:

```bash
west build -s app -b keychron -d build/layers-0-3-r1 -p always -- -DSHIELD=keychron_b1_us
```

The expected artifact is:

```text
build/layers-0-3-r1/zephyr/zmk.uf2
```

Verify that it exists and record its hash:

```bash
test -f build/layers-0-3-r1/zephyr/zmk.uf2
sha256sum build/layers-0-3-r1/zephyr/zmk.uf2
git rev-parse --short HEAD
git status --short
```

Do not treat a successful compile as a deployed firmware revision.

## 8. Prepare the UF2 for Windows-side flashing

WSL is suitable for compiling, but direct flashing from WSL is not recommended.
Copy the completed file to a Windows-accessible staging folder. Replace
`<WindowsUser>` with the Windows account name:

```bash
mkdir -p /mnt/c/Users/<WindowsUser>/Downloads/B1Pro-UF2
cp build/layers-0-3-r1/zephyr/zmk.uf2 /mnt/c/Users/<WindowsUser>/Downloads/B1Pro-UF2/zmk-layers-0-3-r1.uf2
```

Record the staged file's hash in Windows PowerShell:

```powershell
$uf2 = "$env:USERPROFILE\Downloads\B1Pro-UF2\zmk-layers-0-3-r1.uf2"
Get-FileHash -Algorithm SHA256 -LiteralPath $uf2
```

The Windows hash must match the WSL `sha256sum` result.

## 9. Assign the deployment revision and flash

Before copying the UF2 to a physical keyboard, add an entry to the root
`CHANGELOG.md`. The entry must include:

- revision identifier and date;
- UF2 path and SHA-256;
- source commit;
- target test unit;
- purpose of the build; and
- placeholder for the observed hardware result.

Enter the keyboard's UF2 bootloader mode. Confirm the mounted drive is actually
the `NRF52BOOT` volume before copying. In Windows PowerShell, replace `E` with
the mounted drive letter only after verifying it:

```powershell
Get-Volume -DriveLetter E | Select-Object DriveLetter, FileSystemLabel

$uf2 = "$env:USERPROFILE\Downloads\B1Pro-UF2\zmk-layers-0-3-r1.uf2"
Copy-Item -LiteralPath $uf2 -Destination E:\zmk.uf2
```

The bootloader volume normally unmounts after a successful UF2 transfer. That
confirms the host-side copy only; it does not prove keyboard behavior.

## 10. Hardware acceptance checklist

After the keyboard restarts, test the exact behavior changed by the build
before marking the `CHANGELOG.md` entry as successful:

1. Base layer starts and ordinary typing works.
2. Caps taps Escape; holding Caps temporarily enters Layer 1 and release
   returns to Base.
3. Escape taps Escape; holding it for more than 600 ms toggles Caps Lock.
4. Fn hold temporarily enters Layer 1. Fn tap arms the one-shot selector;
   then `1`, `2`, and `3` persistently select Layers 1, 2, and 3.
5. Escape on each persistent layer returns to Base.
6. Layer 1: Q/W/E single taps select Bluetooth profiles 1/2/3; double taps
   enter pairing for the matching profile.
7. Layer 1: minus retains Boot, backslash triggers the screenshot shortcut,
   and Right Shift taps Emoji while holding as Right Shift.
8. G/H activate Symbols; Space and backslash activate Navigation while held.
9. Bilateral home-row modifiers still avoid same-hand phantom modifiers and
   work when chorded with the opposite hand.

Update the pre-created `CHANGELOG.md` entry with the observed result, including
any failed check. Keep a failing image and its SHA-256; do not overwrite it.

## Troubleshooting

| Symptom | Action |
| --- | --- |
| `west: command not found` | Activate `.venv` and reinstall West with `python -m pip install west`. |
| `No module named yaml` or a similar Python module error | Activate `.venv`, then rerun `python -m pip install -r zephyr/scripts/requirements.txt`. |
| CMake cannot find the SDK/toolchain | Recheck the two `ZEPHYR_*` exports and that `$HOME/zephyr-sdk-0.15.2` exists. |
| `git am` fails | Do not force the patch. Inspect `git -C zephyr status --short`, use `git -C zephyr am --abort` if needed, and confirm the intended Keychron Zephyr revision. |
| No `NRF52BOOT` volume appears | Do not copy the UF2. Re-enter the B1 Pro bootloader, then verify the mounted drive label again. |

## References

- [Zephyr Ubuntu host dependencies](https://docs.zephyrproject.org/latest/develop/getting_started/index.html)
- [Zephyr SDK installation and environment variables](https://docs.zephyrproject.org/latest/develop/toolchains/zephyr_sdk.html)
- [Zephyr SDK 0.15.2 release](https://github.com/zephyrproject-rtos/sdk-ng/releases/tag/v0.15.2)
