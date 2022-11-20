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
			      [ ( x : x ) true { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ; buildInputs = [ generate.trace ] ; } "identity" ]
                              [ ( x : builtins.throw "" ) false null "throws" ]
                            ] ;
                          output-tests =
                            [
                              [ ( input : output : input { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ; buildInputs = [ generate.trace ] ; } == output ) "correct" ]
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
	            generate = write-shell-script-bin "generate" "${ pkgs.coreutils }/bin/echo HI" ;
		    write-shell-script-bin =
		      builtins.getAttr
		        system
			argue.lib
			{
			  input-tests = [ ] ;
			  output-tests = [ ] ;
			  lambda = ( input : name : script : input name script ) ;
			  label = "7156ded3-0c3a-4bd1-ac08-669445ac94ed" ;
			  to-string = ( self : "YES" ) ;
			  input = pkgs.writeShellScriptBin ;
			} ;
                    in shell.trace ;
              }
      ) ;
    }
