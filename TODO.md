# dualthrust.github.io — handoff

## Tip

- Branch: `master`
- Tip: `7e63157` — Initial dualthrust website (WASM + R36S PortMaster + GitHub Pages)
- Bundle: `dualthrust-github-io-001.1-initial-site-7e63157.bundle` (artifacts)

## What this is

Static GitHub Pages site for [Grumbel/dualthrust](https://github.com/Grumbel/dualthrust),
mirroring [kurvenrausch.github.io](https://github.com/kurvenrausch/kurvenrausch.github.io):

- `flake.nix` inputs the game flake, builds site = index.html + images + play/ (WASM) + downloads/r36s/
- Deploy: `.github/workflows/pages.yml` → GitHub Actions → Pages
- Local: `nix run .#serve`

## Open / next

- [ ] Confirm WASM output layout (`play/dualthrust.html` vs `play/index.html`) against a real `nix build .#dualthrust-wasm` and adjust the play button href if needed
- [ ] Confirm R36S zip path (`dualthrust-r36s-portmaster-zip/dualthrust.zip`) on a full site build
- [ ] When dualthrust gains Windows / Android packages, add them under `downloads/` like kurvenrausch
- [ ] Optional: more screenshots under `images/`

## Apply the bundle

```bash
git clone /path/to/dualthrust-github-io-001.1-initial-site-7e63157.bundle dualthrust.github.io
# or into an empty repo:
git init dualthrust.github.io && cd dualthrust.github.io
git pull /path/to/dualthrust-github-io-001.1-initial-site-7e63157.bundle HEAD
```
