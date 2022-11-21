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
			( input : pkgs.writeShellScriptBin "generate" "${ pkgs.coreutils }/bin/echo GENERATE ${ input }" )
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
			"Emory Merryman"
                    in shell.trace ;
              }
      ) ;
    }
