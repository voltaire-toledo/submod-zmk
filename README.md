# Zephyr™ Mechanical Keyboard (ZMK) Firmware

[![Discord](https://img.shields.io/discord/719497620560543766)](https://zmk.dev/community/discord/invite)
[![Build](https://github.com/zmkfirmware/zmk/workflows/Build/badge.svg)](https://github.com/zmkfirmware/zmk/actions)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

[ZMK Firmware](https://zmk.dev/) is an open source ([MIT](LICENSE)) keyboard firmware built on the [Zephyr™ Project](https://www.zephyrproject.org/) Real Time Operating System (RTOS). ZMK's goal is to provide a modern, wireless, and powerful firmware free of licensing issues.

Check out the website to learn more: https://zmk.dev/.

You can also come join our [ZMK Discord Server](https://zmk.dev/community/discord/invite).

To review features, check out the [feature overview](https://zmk.dev/docs/). ZMK is under active development, and new features are listed with the [enhancement label](https://github.com/zmkfirmware/zmk/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement) in GitHub. Please feel free to add 👍 to the issue description of any requests to upvote the feature.

[Keychron](https://keychron.com/) use zmk source code for Bpro series keyboards ,have made big changes fro Bpro, also add proprietary 2.4g communication.

To build the firmware ,for example: keychorn b1 pro

prepare:
```    
    mkdir keychron
    cd keychron
    git clone -b keychron_bpro https://github.com/keychron/zmk.git 
    cd zmk
    west init -l app/
    west update
```
patch zephyr:
```
    cd zephyr
    git am ../0001-esb-nrf-fix.patch
    git apply ../0002-zephyr-fix-clang-format-requirement.patch
```
build firmware:
```
    cd app
    west build -b keychron -p -- -DSHIELD=keychron_b1_us
```

## This repository's Git branches

This repository has one writable home and two read-only sources:

- `origin` is our GitHub repository. Push our branches and release tags here.
- `keychron` is Keychron's B1 Pro fork. Fetch vendor updates from it, but do
  not push to it.
- `zmk` is the main ZMK project. Use it for reference or carefully selected
  fixes; do not routinely merge it into the product branch.

In a fresh clone of this repository, add the two source remotes once and
disable their push addresses:

```powershell
git remote add keychron https://github.com/Keychron/zmk.git
git remote add zmk https://github.com/zmkfirmware/zmk.git
git remote set-url --push keychron DISABLED
git remote set-url --push zmk DISABLED
git remote -v
```

The final command should show a normal fetch URL and `DISABLED` as the push URL
for both external sources. An accidental push to either source will then fail.

Think of `mello/b1pro` as the maintained product line. It contains our
QC-passed releases and ongoing B1 Pro work. Published release history should
be merged, not rebased, so a release tag always continues to identify the same
commit.

### Normal local work

Start from the product branch, bring it up to date from our GitHub repository,
then commit and push normally:

```powershell
git switch mello/b1pro
git pull --ff-only origin mello/b1pro

# Make and verify a focused change.
git add <files-for-one-change>
git commit -m "<short description>"
git push origin mello/b1pro
```

`--ff-only` stops Git instead of inventing an unexpected merge when the local
and GitHub histories have diverged.

### Bringing in a Keychron update

Do vendor synchronization on a temporary branch. This keeps an untested vendor
merge away from the known-good product branch:

```powershell
git fetch keychron --prune
git switch mello/b1pro
git pull --ff-only origin mello/b1pro
git switch -c sync/keychron-YYYY-MM-DD
git merge --no-ff keychron/keychron_bpro
```

Resolve any conflicts on the `sync/...` branch, then validate, build without
containers, and run the required regression QC. Only after the synchronization
is accepted:

```powershell
git switch mello/b1pro
git merge --ff-only sync/keychron-YYYY-MM-DD
git push origin mello/b1pro
git branch -d sync/keychron-YYYY-MM-DD
```

Fetch `zmk` when main-project history is useful:

```powershell
git fetch zmk --prune
```

Prefer a deliberate cherry-pick or a separately reviewed port from `zmk`.
Keychron's fork contains vendor-specific B1 Pro and 2.4 GHz work that a direct
mainline merge may conflict with.

### Release tags

After a QC-passed release has one exact source commit and its archived hashes
are verified, create an annotated, product-namespaced tag:

```powershell
git tag -a mello-b1pro-v0.23 -m "B1 Pro v0.23 QC-passed release"
git push origin mello-b1pro-v0.23
```

The release keymaps, UF2 files, QC records, design material, backlog, and live
handoff are kept under [`B1PRO/`](B1PRO/).
