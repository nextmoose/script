  {
      inputs =
        {
          nixpkgs.url = "github:nixos/nixpkgs" ;
          flake-utils.url = "github:numtide/flake-utils" ;
	  shell.url = "github:nextmoose/shell" ;
        } ;
      outputs =
        { self , nixpkgs , flake-utils , shell } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                devShell =
		  builtins.getAttr
		    system
		    shell.lib
		    nixpkgs
		    (
		      structure :  "${ structure.pkgs.coreutils }/bin/echo HELLO THERE"
		    ) ;
              }
      ) ;
    }
