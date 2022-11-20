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
                    arguex = builtins.getAttr system argue.lib ;
                    shell =
                      arguex
                        {
                          input-tests =
                            [
                              [ ( x : null ) true null "probably true 1" ]
                              [ ( x : true ) true true "probably true 2" ]
                              [ ( x : false ) true false "probably true 3" ]
                              [ ( x : builtins.throw "" ) false null "probably true 4" ]
                            ] ;
                          output-tests =
                            [
                              [ ( input : output : input { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ; buildInputs = [ ] ; } == output ) "correct" ]
                            ] ;
                          lambda =
                            (
                              input :
                                input
                                  {
                                    shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ;
                                    buildInputs = [ ] ;
                                  }
                            ) ;
                          label = "af00e578-b50a-42ba-b13c-808cb8de3af7" ;
                          to-string = ( self : "OK" ) ;
                          input = pkgs.mkShell ;
                        } ;
                    in builtins.trace shell.test ( pkgs.mkShell { } ) ;
                    # in pkgs.mkShell { shellHook = "${ pkgs.coreutils }/bin/echo hi ${ builtins.concatStringsSep " , " ( builtins.attrNames nixos-structure-argue ) }" ; } ;
              }
      ) ;
    }
