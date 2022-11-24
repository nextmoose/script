  {
      inputs =
        {
          nixpkgs.url = "github:nixos/nixpkgs" ;
          flake-utils.url = "github:numtide/flake-utils" ;
          utils.url = "github:nextmoose/utils" ;
        } ;
      outputs =
        { self , nixpkgs , flake-utils , utils } :
          flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                devShell = builtins.getAttr "mkShell" ( builtins.getAttr system nixpkgs.legacyPackages ) { } ;
              }
      ) ;
    }
