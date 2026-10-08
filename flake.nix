# SPDX-FileCopyrightText: 2026 Ingo Ruhnke <grumbel@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
#
# dualthrust website: static landing page + WASM and the R36S PortMaster
# zip from the game flake + GitHub Pages. Same shape as
# kurvenrausch.github.io / SuperTux-Origins.github.io.
#
#   nix build          # → result/ (index.html, images/, play/, downloads/)
#   nix run .#serve    # local preview
#
{
  description = "dualthrust website (WASM + GitHub Pages), Nix-first";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # git+https, not github: only a git fetch carries the commit count the
    # game's version (0.2.0-dev.<count>+g<rev>) is made of.
    dualthrust.url = "git+https://github.com/Grumbel/dualthrust";
    dualthrust.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, dualthrust }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        game = dualthrust.packages.${system};
        version = game.dualthrust.version;

        site = pkgs.runCommand "dualthrust-site" { } ''
          mkdir -p $out
          substitute ${./index.html} $out/index.html --subst-var-by version ${version}
          cp -rv ${./images} $out/images

          # Playable WASM build from the game flake (html/js/wasm + index.html).
          mkdir -p $out/play
          cp -rv ${game.dualthrust-wasm}/. $out/play/
          chmod -R u+w $out/play

          # R36S PortMaster zip under a stable name so the page's links
          # never change (the version is on the page).
          mkdir -p $out/downloads/r36s
          cp -v ${game.dualthrust-r36s-portmaster-zip}/dualthrust.zip \
               $out/downloads/r36s/dualthrust.zip
          chmod -R u+w $out/downloads
        '';

        serveApp = {
          type = "app";
          program = toString (pkgs.writeShellScript "serve-dualthrust-site" ''
            set -euo pipefail
            export PKG="${site}"
            export DUALTHRUST_PORT="''${DUALTHRUST_PORT:-8765}"
            exec ${./scripts/serve.sh}
          '');
        };
      in {
        packages = {
          default = site;
          site = site;
        };

        apps = {
          default = serveApp;
          serve = serveApp;
        };
      });
}
