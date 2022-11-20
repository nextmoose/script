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
                              [ ( x : null ) true null "probably true 1" ]
                              [ ( x : true ) true true "probably true 2" ]
                              [ ( x : false ) true false "probably true 3" ]
                              [ ( x : builtins.throw "" ) false null "probably true 4" ]
                            ] ;
                          output-tests =
                            [
                              [ ( input : output : input { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ; buildInputs = [ write-shell-script-bin.trace ] ; } == output ) "correct" ]
                            ] ;
                          lambda =
                            (
                              input :
                                input
                                  {
                                    shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ;
                                    buildInputs = [ write-shell-script-bin.trace ] ;
                                  }
                            ) ;
                          label = "af00e578-b50a-42ba-b13c-808cb8de3af7" ;
                          to-string = ( self : "OK" ) ;
                          input = pkgs.mkShell ;
                        } ;
		    write-shell-script-bin =
		      builtins.getAttr
		        system
			argue.lib
			{
			  input-tests = [ ] ;
			  output-tests = [ ] ;
			  lambda = ( input : input "generate" "${ pkgs.coreutils }/bin/echo HELLO" ) ;
			  label = "7156ded3-0c3a-4bd1-ac08-669445ac94ed" ;
			  to-string = ( self : "YES" ) ;
			  input = pkgs.writeShellScriptBin ;
			} ;
                    in shell.trace ;
              }
      ) ;
    }
