  {
      inputs =
        {
          nixpkgs.url = "github:nixos/nixpkgs" ;
          flake-utils.url = "github:numtide/flake-utils" ;
          argue.url = argue ;
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
		    inputx =
		      arguex
		        [
		          [ ( x : null ) true null "probably OK" ]
		        ]
		        [
		          [ ( utils : input : output : input "${ pkgs.coreutils }/bin/echo HI" == output ) "yes" ]
		        ]
		        (
		          utils : input : input "${ pkgs.coreutils }/bin/echo HI"
		        )
		        "0718f79a-4d6e-476a-8b76-6cecc6c67a33"
		        ( self : "YES" )
		        ( pkgs.writeShellScriptBin "generate" ) ;
                    shell =
                      arguex
                        [
                          [ ( x : null ) true null "probably true" ]
                          [ ( x : true ) true true "probably true" ]
                          [ ( x : false ) true false "probably true" ]
                          [ ( x : builtins.throw "" ) false null "probably true" ]
                        ]
                        [
                          [ ( utils : input : output : input { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ; buildInputs = [ inputx.trace ] ; } == output ) "correct" ]
                        ]
                        (
                          utils : input : input { shellHook = "${ pkgs.coreutils }/bin/echo WELCOME!" ; buildInputs = [ inputx.trace ] ; }
                        )
                        "af00e578-b50a-42ba-b13c-808cb8de3af7"
                        ( self : "OK" )
                        pkgs.mkShell ;
                    in shell.output ;
		    # in pkgs.mkShell { shellHook = "${ pkgs.coreutils }/bin/echo hi ${ builtins.concatStringsSep " , " ( builtins.attrNames nixos-structure-argue ) }" ; } ;
              }
      ) ;
    }
