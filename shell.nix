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
	      "commit"
	      ''
	        ${ pkgs.git }/bin/git commit --all --allow-empty --allow-empty-message --message "" &&
		${ pkgs.git }/bin/git -C ${ builtins.concatStringsSep "" [ "$" "{" "1" "}" ] } commit --all --allow-empty --allow-empty-message --message ""
	      ''
	  )
          (
            pkgs.writeShellScriptBin
              "initiate"
              (
                let
                  argue-commit = dollar "ARGUE_COMMIT" ;
                  argue-dir = dollar "1" ;
                  bin-time = dollar "BIN_TIME" ;
                  dollar = expression : builtins.concatStringsSep "" [ "$" "{" expression "}" ] ;
                  shell-commit = dollar "SHELL_COMMIT" ;
                  work-dir = dollar "WORK_DIR" ;
                  in
                    ''
                      WORK_DIR=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
                      function cleanup ( )
                      {
                        ${ pkgs.coreutils }/bin/echo ${ pkgs.coreutils }/bin/rm --recursive --force ${ work-dir }
                      } &&
                      trap cleanup EXIT &&
                      SHELL_COMMIT=${ dollar "SHELL_COMMIT:=$( ${ pkgs.git }/bin/git -C $( ${ pkgs.coreutils }/bin/pwd ) rev-parse HEAD )" } &&
                      ARGUE_COMMIT=${ dollar "ARGUE_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ argue-dir } rev-parse HEAD )" } &&
                      BIN_TIME=$( ${ pkgs.coreutils }/bin/date +Y%m%d%H%M%S ) &&
                      ${ pkgs.coreutils }/bin/mkdir ${ work-dir }/argue &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/argue init &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/argue config user.name "No One" &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/argue config user.email "no@one" &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/argue remote add origin ${ argue-dir } &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/argue fetch origin ${ argue-commit } &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/argue checkout ${ argue-commit } &&
                      ${ pkgs.coreutils }/bin/mkdir ${ work-dir }/shell &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/shell init &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/shell config user.name "No One" &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/shell config user.email "no@one" &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/shell remote add origin $( ${ pkgs.coreutils }/bin/pwd ) &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/shell fetch origin ${ shell-commit } &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/shell checkout ${ shell-commit } &&
                      ${ pkgs.gnused }/bin/sed -e "s#github:nextmoose/argue#${ work-dir }/argue#" -e "w${ work-dir }/shell/flake.nix" flake.nix &&
                      ( ${ pkgs.coreutils }/bin/cat > bin/${ bin-time } <<EOF
                      #!/bin/sh
                      
                      export SHELL_COMMIT=${ shell-commit } &&
                      export ARGUE_COMMIT=${ argue-commit } &&
                      initiate ${ argue-dir }
                      EOF
                      ) &&
                      ${ pkgs.coreutils }/bin/chmod 0500 bin/${ bin-time } &&
                      ${ pkgs.nix }/bin/nix develop --impure ${ work-dir }/shell/flake.nix
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
