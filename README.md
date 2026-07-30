> [!NOTE] 💡
> This repo is forked from keychron/zmk, which was also formed from zmkfirmware/zmk. Pushes from this repo cannot be pushed to either upstreams, but fetches are allowed.
> Go to the [**Custom ZMK...**](#custom-zmk-firmware-for-keychron-b1-pro) to get started with what's unique about this repo.

# Zephyr™ Mechanical Keyboard (ZMK) Firmware

![GitHub License](https://img.shields.io/github/license/mashape/apistatus?branch=main&label=License&logo=GitHub&logoColor=ffffff&labelColor=282828&color=informational&style=flat)

[ZMK Firmware](https://zmk.dev/) is an open source ([MIT](LICENSE)) keyboard firmware built on the [Zephyr™ Project](https://www.zephyrproject.org/) Real Time Operating System (RTOS). ZMK's goal is to provide a modern, wireless, and powerful firmware free of licensing issues.

Check out the website to learn more: https://zmk.dev/.

You can also come join our [ZMK Discord Server](https://zmk.dev/community/discord/invite).

To review features, check out the [feature overview](https://zmk.dev/docs/). ZMK is under active development, and new features are listed with the [enhancement label](https://github.com/zmkfirmware/zmk/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) in GitHub. Please feel free to add 👍 to the issue description of any requests to upvote the feature.

---

## Custom ZMK Firmware for Keychron B1 Pro

![Keychron B1 Pro Keyboard](B1PRO/images/B1Pro-Showcase.png)

[Keychron](https://keychron.com/) uses ZMK source code for B-Series keyboards including some significant changes from the original source, including the addition of proprietary 2.4G communication. This repo is the landing zone for a custom Keychron B1 Pro keymap, but with my take on how I can make it work best for me.

### Myths and Undocumented Information

### What this means to you

> [!NOTE] 💬
> If you stumbled on to this repo, it definitely wasn't because I was personally promoting it. But I wish I had someone showed this to me before I had to go down the rabbit hole of firmware programming. Part of the fun is that it's a little niche, with a relatively small community of folks who weren't so jaded and randomly assaulted by regulars at Stack Overflow, _where programmers eat their young_.

#### You could try the firmware:

I wouldn't ever recommend downloading and installing firmware without thoroughly reviewing it. But for each firmware update, there is an accompanying keymap with comments an illustrations you can `diff`.

1. Download one of the firmware [releases](./B1PRO/releases/) and read through the changes and their keymap.
2. Set your keyboard into Boot mode - switch the Physical Toggle to **Mac** and the Connection Type switch to **Cable**.
3. Hold down the <kbd>Fn</kbd>+<kbd>-</kbd> keys immediate after plugging in the USB cable. You should see the keyboard LED pulse-glowing in blue.
4. If successful, then you will also see that your system has mounted a new removable storage with a volume name similar to `NRF...BOOT`. That's the keyboard.
5. Copy the UF2 file to that storage device. It will abruptly disconnect after successfully uploading it, so your system might present an error or warning - just ignore it.
6. What is important is that after it disconnects, the LED light on the keyboard turns GREEN. If so, then the firmware upload was successful.

#### Or customize and build your own

> [!IMPORTANT]
> B1 Pro firmware builds in this repository do not use Docker. Use the native
> WSL workflow when it is available. The validated Windows fallback uses
> PowerShell 7, Python 3.11, the repository's `.venv`, Zephyr SDK 0.15.2, and
> serialized Ninja (`-j1`).

Start with this repository-not a fresh Keychron checkout-so the custom B1 Pro
source and both required Zephyr patches are available:

```powershell
git clone https://github.com/voltaire-toledo/Keychron-B1-Pro-Custom-Keymap.git
Set-Location .\Keychron-B1-Pro-Custom-Keymap

py -3.11 -m venv .venv
.\.venv\Scripts\python.exe -m pip install --upgrade pip
.\.venv\Scripts\python.exe -m pip install west ninja cmake
& .\.venv\Scripts\python.exe -m west init -l app
& .\.venv\Scripts\python.exe -m west update
.\.venv\Scripts\python.exe -m pip install -r app\scripts\requirements.txt
```

Patch the downloaded Zephyr workspace once:

```powershell
Push-Location .\zephyr
git am ..\0001-esb-nrf-fix.patch
git apply ..\0002-zephyr-fix-clang-format-requirement.patch
Pop-Location
```

Do not force either patch if Git reports that it is already applied. The build
input is
`app\boards\shields\keychron\b1\us\keychron_b1_us.keymap`. Make changes in a
working candidate; never edit an approved file under `B1PRO/releases/` in place.

Install [Zephyr SDK 0.15.2](https://github.com/zephyrproject-rtos/sdk-ng/releases/tag/v0.15.2),
then configure and compile the B1 Pro target. The example below uses the
repository-local SDK location from the validated Windows lab. Extract the SDK
there, or change `$Sdk` to its exact installation directory:

```powershell
$Repo = (Resolve-Path .).Path
$Sdk = Join-Path $Repo '.isolated-builds\sdk-r1\zephyr-sdk-0.15.2'
$CMakeBin = Join-Path $Repo '.venv\Lib\site-packages\cmake\data\bin'
$Python = Join-Path $Repo '.venv\Scripts\python.exe'
$BuildDir = 'build\local-b1pro'

$env:PATH = "$CMakeBin;$(Join-Path $Repo '.venv\Scripts');$env:PATH"
$env:ZEPHYR_TOOLCHAIN_VARIANT = 'zephyr'
$env:ZEPHYR_SDK_INSTALL_DIR = $Sdk

& $Python -m west build -s app -b keychron -d $BuildDir -p always --cmake-only -- -DSHIELD=keychron_b1_us
if ($LASTEXITCODE -ne 0) { throw 'CMake configuration failed.' }

& ninja -C $BuildDir -j1
if ($LASTEXITCODE -ne 0) { throw 'Firmware compilation failed.' }
```

The UF2 is created at `build\local-b1pro\zephyr\zmk.uf2`. Hash it before
testing:

```powershell
Get-FileHash -Algorithm SHA256 .\build\local-b1pro\zephyr\zmk.uf2
```

A successful build proves that the firmware configured, compiled, and linked;
it does not prove hardware behavior or qualify the UF2 for `releases/`. See the
native WSL build guide
or the [Windows developer lab](./B1PRO/B1Pro-ZMK-Developer-Lab.md) for the
complete validation and release workflow.

## This repository's Git branches

This repository has one writable home and two read-only sources:

- `origin` is our GitHub repository. Push our branches and release tags here.
- `keychron` is Keychron's B1 Pro fork. Fetch vendor updates from it, but do not push to it.
- `zmk` is the main ZMK project. Use it for reference or carefully selected fixes; do not routinely merge it into the product branch.

In a fresh clone of this repository, add the two source remotes once and disable their push addresses:

```powershell
git remote add keychron https://github.com/Keychron/zmk.git
git remote add zmk https://github.com/zmkfirmware/zmk.git
git remote set-url --push keychron DISABLED
git remote set-url --push zmk DISABLED
git remote -v
```

The final command should show a normal fetch URL and `DISABLED` as the push URL for both external sources. An accidental push to either source will then fail.

Think of `vt/main-branch` as the maintained product line. It contains our QC-passed releases and ongoing B1 Pro work. Published release history should be merged, not rebased, so a release tag always continues to identify the same commit.

### Normal local work

Start from the product branch, bring it up to date from our GitHub repository, then commit and push normally:

```powershell
git switch vt/main-branch
git pull --ff-only origin vt/main-branch

# Make and verify a focused change.
git add <files-for-one-change>
git commit -m "<short description>"
git push origin vt/main-branch
```

`--ff-only` stops Git instead of inventing an unexpected merge when the local and GitHub histories have diverged.

### Bringing in a Keychron update

Do vendor synchronization on a temporary branch. This keeps an untested vendor merge away from the known-good product branch:

```powershell
git fetch keychron --prune
git switch vt/main-branch
git pull --ff-only origin vt/main-branch
git switch -c sync/keychron-YYYY-MM-DD
git merge --no-ff keychron/keychron_bpro
```

Resolve any conflicts on the `sync/...` branch, then validate, build without containers, and run the required regression QC. Only after the synchronization is accepted:

```powershell
git switch vt/main-branch
git merge --ff-only sync/keychron-YYYY-MM-DD
git push origin vt/main-branch
git branch -d sync/keychron-YYYY-MM-DD
```

Fetch `zmk` when main-project history is useful:

```powershell
git fetch zmk --prune
```

Prefer a deliberate cherry-pick or a separately reviewed port from `zmk`. Keychron's fork contains vendor-specific B1 Pro and 2.4 GHz work that a direct mainline merge may conflict with.

### Release tags

After a QC-passed release has one exact source commit and its archived hashes are verified, create an annotated, product-namespaced tag:

```powershell
git tag -a mello-b1pro-v0.23 -m "B1 Pro v0.23 QC-passed release"
git push origin mello-b1pro-v0.23
```

Release keymaps and UF2 files are kept under [`B1PRO/releases/`](./B1PRO/releases/). Design material, images, and the native Windows developer lab are also kept under [`B1PRO/`](./B1PRO/).
