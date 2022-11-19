{ pkgs ? import ( fetchTarball "https://github.com/NixOS/nixpkgs/archive/bf972dc380f36a3bf83db052380e55f0eaa7dcb6.tar.gz" ) {} } :
  pkgs.mkShell
    {
      buildInputs =
        [
          pkgs.chromium
          pkgs.coreutils
          pkgs.emacs
          pkgs.inetutils
          (
            pkgs.writeShellScriptBin
              "initiate"
              ''
                ${ pkgs.nix }/bin/nix develop --override-flake argue ${ builtins.concatStringsSep "" [ "$" "{" "1" "}" ] } --impure
              ''
          )
          (
            pkgs.writeShellScriptBin
              "registry-add"
              ''
                ${ pkgs.nix }/bin/nix registry add argue github:nextmoose/argue
              ''
          )
          (
            pkgs.writeShellScriptBin
              "registry-list"
              ''
                ${ pkgs.nix }/bin/nix registry list
              ''
          )
          (
            pkgs.writeShellScriptBin
              "registry-remove"
              ''
                ${ pkgs.nix }/bin/nix registry remove argue
              ''
          )
        ] ;
      shellHook =
        ''
          ${ pkgs.coreutils }/bin/echo STRUCTURE FLAKE DEVELOPMENT ENVIRONMENT
        '' ;
    }
