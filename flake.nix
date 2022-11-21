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
                        {
                          input-tests =
                            [
			      [ ( x : x ) true { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ; buildInputs = [ ] ; } "identity" ]
                              [ ( x : builtins.throw "" ) false null "throws" ]
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
                    in shell.trace ;
              }
      ) ;
    }
