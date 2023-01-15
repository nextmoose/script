  {
      inputs =
        {
          flake-utils.url = "github:numtide/flake-utils" ;
          nixpkgs.url = "github:nixos/nixpkgs" ;
          utils.url = "github:nextmoose/utils" ;
        } ;
      outputs =
        { self , flake-utils , nixpkgs , utils } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                lib =
                  negatives :
                    {
                      devShell =
                        let
                          _utils = builtins.getAttr system utils.lib ;
                          close = builtins.concatStringsSep "" [ "}" ] ;
                          flake =
                            name : value :
                              ''
                                {
                                  inputs = { flake-utils.url = "github:numtide/flake-utils" ; nixpkgs.url = "github:nixos/nixpkgs" ; test.url = "/home/runner/work/strip/strip" ; } ;
                                  outputs =
                                    { self , flake-utils , nixpkgs , test } :
                                    flake-utils.lib.eachDefaultSystem
                                      (
                                        system :
                                          let
                                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                                            testee = builtins.getAttr system test.lib ;
                                            in { devShell = pkgs.mkShell { buildInputs = [ ( pkgs.writeShellScriptBin "check" ( ${ value.observed "testee" } ) ) ] ; } ; }
                                      ) ;
                                }
                              '' ;
                          pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                          mapper =
                            name : value :
                              pkgs.writeShellScript
                                name
                                ''
                                  cd $( ${ pkgs.coreutils }/bin/mktemp --directory ) &&
                                  ${ pkgs.git }/bin/git init &&
                                  ${ pkgs.git }/bin/git config user.name "NO" &&
                                  ${ pkgs.git }/bin/git config user.email "no@no" &&
                                  ${ pkgs.nix }/bin/nix flake init &&
                                  ${ pkgs.coreutils }/bin/cat ${ builtins.toFile "flake" ( flake name value ) } > flake.nix &&
                                  ${ pkgs.coreutils }/bin/cat flake.nix &&
                                  ${ pkgs.git }/bin/git commit --all --allow-empty-message --message "" &&
                                  ! ${ pkgs.nix }/bin/nix develop --command check &&
                                  ! OBSERVED="$( ${ pkgs.nix }/bin/nix develop --command check 2> >( ${ pkgs.coreutils }/bin/tee | ${ pkgs.coreutils }/bin/tail --lines 2 | ${ pkgs.coreutils }/bin/head --lines 1 ) )" &&
                                  EXPECTED="error: ${ value.expected }" &&
                                  if [ "${ _utils.bash-variable "EXPECTED" }" == "${ _utils.bash-variable "OBSERVED" }" ]
                                  then
                                    ( ${ pkgs.coreutils }/bin/cat <<EOF
                                  #
                                  TEST="GOOD"
                                  TYPE="NEGATIVE"
                                  NAME="${ name }"
                                  HASH="${ _utils.bash-variable "EXPECTED" }"
                                  EOF
                                    )
                                  else
                                    ( ${ pkgs.coreutils }/bin/cat <<EOF
                                  #
                                  TEST="BAD"
                                  TYPE="NEGATIVE"
                                  NAME="${ name }"
                                  OBSERVED="${ _utils.bash-variable "OBSERVED" }"
                                  EXPECTED="${ _utils.bash-variable "EXPECTED" }"
                                  EOF
                                    ) &&
                                    exit 64
                                  fi
                                '' ;
                          open = builtins.concatStringsSep "" [ "$" "{" ] ;
                          in pkgs.mkShell
                            {   
                              buildInputs =
                                [ ( pkgs.writeShellScriptBin "check" ( builtins.concatStringsSep " &&\n" ( builtins.attrValues ( builtins.mapAttrs mapper negatives ) ) ) ) ] ;
                            } ;
                    } ;
              }
      ) ;
    }