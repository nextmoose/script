  {
      inputs =
        {
          nixpkgs.url = "github:nixos/nixpkgs" ;
          flake-utils.url = "github:numtide/flake-utils" ;
          argue.url = "github:nextmoose/argue" ;
        } ;
      outputs =
        { self , nixpkgs , flake-utils , argue } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                devShell =
                  let
                    pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                    generate =
                      builtins.getAttr
                        system
                        argue.lib
                        [
                        ]
                        [
                        ]
                        (
                          input :
                            pkgs.writeShellScriptBin
                            "generate"
                            ''
                              while [ $# -gt 0 ]
                              do
                                case $1 in
                                  --resource-directory)
                                    RESOURCE_DIRECTORY=$2 &&
                                      shift 2 &&
                                      break
                                    ;;
                                  --private-file)
                                    PRIVATE_FILE=$2 &&
                                      shift 2 &&
                                      break
                                    ;;
                                  --shell-hook)
                                    SHELL_HOOK=$2 &&
                                      shift 2 &&
                                      break
                                    ;;
                                  *)
                                    ${ pkgs.coreutils }/bin/echo UNEXPECTED &&
                                      ${ pkgs.coreutils }/bin/echo $1 &&
                                      ${ pkgs.coreutils }/bin/echo $@ &&
                                      exit 64
                                    ;;
                                ecase
                              done &&
                                SOURCE_DIRECTORY=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
                                ${ pkgs.coreutils }/bin/cp ${ ./src/flake.nix } $SOURCE_DIRECTORY/flake.nix &&
                                ${ pkgs.coreutils }/bin/chmod 0400 $SOURCE_DIRECTORY/flake.nix &&
                                ${ pkgs.coreutils }/bin/echo $SOURCE_DIRECTORY
                            ''
                        )
                        "cd2330a5-67d3-4919-800a-2ab8edb5d33e"
                        ( self : "OK2" )
                        "IT" ;
                    shell =
                      builtins.getAttr
                        system
                        argue.lib
                        [
                          [
                            "eecebe2b-135e-4f53-a942-8812a66c7467"
                            true
                            (
                              pkgs.mkShell
                                {
                                  buildInputs = [ generate.trace ] ;
                                  shellHook = "${ pkgs.coreutils }/bin/echo WELCOME eecebe2b-135e-4f53-a942-8812a66c7467" ;
                                }
                            )
                            "identity"
                          ]
                        ]
                        [
                          [
                            ( name : pkgs.mkShell { buildInputs = [ generate.trace ] ; shellHook = "${ pkgs.coreutils }/bin/echo WELCOME ${ name }" ; } )
                            "correct"
                          ]
                        ]
                        (
                          name :
                            pkgs.mkShell
                              {
                                buildInputs = [ generate.trace ] ;
                                shellHook = "${ pkgs.coreutils }/bin/echo WELCOME ${ name }" ;
                              }
                        )
                        "af00e578-b50a-42ba-b13c-808cb8de3af7"
                        ( self : "OK" )
                        "Emory Merryman" ;
                    scripts =
                      resource-directory : private : scripts :
                        {
                        } ;
                    in shell.trace ;
              }
      ) ;
    }
