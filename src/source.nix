  {
      inputs =
        {
          nixpkgs.url = "github:nixos/nixpkgs" ;
          flake-utils.url = "github:numtide/flake-utils" ;
        } ;
      outputs =
        { self , nixpkgs , flake-utils } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                devShell =
		  pkgs.mkShell
		    {
		      shellHook =
		        ''
			  ${ pkgs.coreutils }/bin/echo HI
			''
		    } ;
              }
      ) ;
    }
