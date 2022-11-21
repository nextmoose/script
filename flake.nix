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
                        ]
                        [
                          [
			    ( first-name : last-name : pkgs.mkShell { buildInputs = [ ] ; shellHook = "${ pkgs.coreutils }/bin/echo WELCOME ${ first-name } ${ last-name }" ; } )
			    "correct"
			  ]
                        ]
                        (
                          first-name : last-name :
                            pkgs.mkShell
                              {
                                shellHook = "${ pkgs.coreutils }/bin/echo WELCOME ${ first-name } ${ last-name}" ;
                              }
                        )
                        "af00e578-b50a-42ba-b13c-808cb8de3af7"
                        ( self : "OK" )
			"Emory"
			"Merryman" ;
                    in shell.trace ;
              }
      ) ;
    }
