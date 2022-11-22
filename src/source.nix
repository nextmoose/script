  {
      inputs =
        {
          nixpkgs.url = "github:nixos/nixpkgs" ;
          flake-utils.url = "github:numtide/flake-utils" ;
        } ;
      outputs =
        { self , nixpkgs , flake-utils } :
	  let
	    destination-directory = builtins.readFile ./destination-directory.txt ;
	    private = builtins.import ./private.nix ;
	    resource-directory = builtins.readFile ./resource-directory.txt ;
            in
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
