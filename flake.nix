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
                    shell =
                      builtins.getAttr
		        system
			argue.lib
                        [
			  [ "eecebe2b-135e-4f53-a942-8812a66c7467" true ( pkgs.mkShell { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME eecebe2b-135e-4f53-a942-8812a66c7467" ; } ) "identity" ]
                        ]
                        [
                          [ ( input : output : pkgs.mkShell { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME ${ input }" } == output ) "correct" ]
                        ]
                        (
                          input :
                            pkgs.mkShell
                              {
                                shellHook = "${ pkgs.coreutils }/bin/echo WELCOME ${ input }" ;
                              }
                        )
                        "af00e578-b50a-42ba-b13c-808cb8de3af7"
                        ( self : "OK" )
			"Emory Merryman"
                    in shell.trace ;
              }
      ) ;
    }
