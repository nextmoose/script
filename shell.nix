{ pkgs ? import ( fetchTarball "https://github.com/NixOS/nixpkgs/archive/bf972dc380f36a3bf83db052380e55f0eaa7dcb6.tar.gz" ) {} } :
  pkgs.mkShell
    {
      buildInputs =
        [
          pkgs.chromium
          pkgs.coreutils
          pkgs.emacs
          pkgs.inetutils
          (
            pkgs.writeShellScriptBin
              "initiate"
	      (
	        let
		  master-dir = builtins.concatStringsSep "" [ "$" "{" "1" "}" ] ;
		  work-dir = builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] ;
		  in
                    ''
	              WORK_DIR=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
		      function cleanup ( )
		      {
		        ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/rm --recursive --force ${ work-dir }
		      } &&
		      trap cleanup EXIT &&
		      ${ pkgs.coreutils }/bin/mkdir ${ work-dir }/parent &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/parent init &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/parent config user.name "No One" &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/parent config user.email "no@one" &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/parent remote add origin ${ master-dir } &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/parent fetch origin $( ${ pkgs.git }/bin/git -C ${ master-dir } rev-parse HEAD ) &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/parent checkout $( ${ pkgs.git }/bin/git -C ${ master-dir } rev-parse HEAD ) &&
		      ${ pkgs.coreutils }/bin/mkdir ${ work-dir }/child &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/child init &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/child config user.name "No One" &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/child config user.email "no@one" &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/child remote add origin $( ${ pkgs.coreutils }/bin/pwd ) &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/child fetch origin $( ${ pkgs.git }/bin/git -C $( ${ pkgs.coreutils }/bin/pwd ) rev-parse HEAD ) &&
		      ${ pkgs.git }/bin/git -C ${ work-dir }/child checkout $( ${ pkgs.git }/bin/git -C $( ${ pkgs.coreutils }/bin/pwd ) rev-parse HEAD ) &&
	              ${ pkgs.gnused }/bin/sed -e "s#github:nextmoose/argue#${ work-dir }#" -e "w${ work-dir }/child/flake.nix" flake.nix &&
                      ${ pkgs.nix }/bin/nix develop --impure ${ work-dir }/child/flake.nix
                    ''
              )
	  )
          (
            pkgs.writeShellScriptBin
              "registry-add"
              ''
                ${ pkgs.nix }/bin/nix registry add argue github:nextmoose/argue
              ''
          )
          (
            pkgs.writeShellScriptBin
              "registry-list"
              ''
                ${ pkgs.nix }/bin/nix registry list
              ''
          )
          (
            pkgs.writeShellScriptBin
              "registry-remove"
              ''
                ${ pkgs.nix }/bin/nix registry remove argue
              ''
          )
        ] ;
      shellHook =
        ''
          ${ pkgs.coreutils }/bin/echo STRUCTURE FLAKE DEVELOPMENT ENVIRONMENT
        '' ;
    }
