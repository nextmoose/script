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
			  [ ( x : x ) true { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ; buildInputs = [ ] ; } "identity" ]
                          [ ( x : builtins.throw "" ) false null "throws" ]
                        ]
                        [
                          [ ( input : output : input { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ; buildInputs = [ ] ; } == output ) "correct" ]
                        ]
                        (
                          input :
                            input
                              {
                                shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ;
                                buildInputs = [ ] ;
                              }
                        )
                        "af00e578-b50a-42ba-b13c-808cb8de3af7"
                        ( self : "OK" )
                        pkgs.mkShell ;
                    in shell.trace ;
              }
      ) ;
    }
