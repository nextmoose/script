{ pkgs ? import ( fetchTarball "https://github.com/NixOS/nixpkgs/archive/bf972dc380f36a3bf83db052380e55f0eaa7dcb6.tar.gz" ) {} } :
  pkgs.mkShell
    {
      buildInputs =
        let
          apply-commit = dollar "APPLY_COMMIT" ;
          argue-commit = dollar "ARGUE_COMMIT" ;
          apply-dir = dollar "1" ;
          argue-dir = dollar "2" ;
          bin-time = dollar "BIN_TIME" ;
          dollar = expression : builtins.concatStringsSep "" [ "$" "{" expression "}" ] ;
          shell-commit = dollar "SHELL_COMMIT" ;
          utils-commit = dollar "UTILS_COMMIT" ;
          utils-dir = dollar "3" ;
          work-dir = dollar "WORK_DIR" ;
          in
            [
              pkgs.chromium
              pkgs.coreutils
              pkgs.emacs
              pkgs.inetutils
              (
                pkgs.writeShellScriptBin
                  "commit"
                  ''
                    ${ pkgs.git }/bin/git -C ${ dollar "APPLY_HOME" } commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }" &&
                    ${ pkgs.git }/bin/git -C ${ dollar "ARGUE_HOME" } commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }" &&
                    ${ pkgs.git }/bin/git -C ${ dollar "UTILS_HOME" } commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }" &&
                    ${ pkgs.git }/bin/git commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }"
                  ''
              )
              (
                pkgs.writeShellScriptBin
                  "edit"
                  ''
                    ${ pkgs.emacs }/bin/emacs shell.nix flake.nix ${ dollar "APPLY_HOME" }/flake.nix ${ dollar "ARGUE_HOME" }/flake.nix ${ dollar "UTILS_HOME" }/flake.nix &
                  ''
              )
              (
                pkgs.writeShellScriptBin
                  "initiate"
                  ''
                    WORK_DIR=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
                    function cleanup ( )
                    {
                      if [ ${ dollar "?" } -eq 0 ]
                        then
                          ${ pkgs.git }/bin/git -C ${ dollar "APPLY_HOME" } commit --all --allow-empty --message "TESTED" &&
                          ${ pkgs.git }/bin/git -C ${ dollar "ARGUE_HOME" } commit --all --allow-empty --message "TESTED" &&
                          ${ pkgs.git }/bin/git commit --all --allow-empty --message "TESTED"
                          ${ pkgs.coreutils }/bin/rm --recursive --force ${ work-dir }
                        else
                          ${ pkgs.coreutils }/bin/echo There was a problem with ${ work-dir } - ${ dollar "?" }
                        fi
                    } &&
                    trap cleanup EXIT &&
                    ${ pkgs.git }/bin/git -C ${ dollar "APPLY_HOME" } commit --all --allow-empty --allow-empty-message --message "" &&
                    APPLY_COMMIT=${ dollar "APPLY_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ apply-dir } rev-parse HEAD )" } &&
                    ${ pkgs.git }/bin/git -C ${ dollar "ARGUE_HOME" } commit --all --allow-empty --allow-empty-message --message "" &&
                    ARGUE_COMMIT=${ dollar "ARGUE_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ argue-dir } rev-parse HEAD )" } &&
                    ${ pkgs.git }/bin/git commit --all --allow-empty --allow-empty-message --message ""
                    SHELL_COMMIT=${ dollar "SHELL_COMMIT:=$( ${ pkgs.git }/bin/git -C $( ${ pkgs.coreutils }/bin/pwd ) rev-parse HEAD )" } &&
                    ${ pkgs.git }/bin/git -C ${ dollar "UTILS_HOME" } commit --all --allow-empty --allow-empty-message --message ""
                    UTILS_COMMIT=${ dollar "UTILS_COMMIT:=$( ${ pkgs.git }/bin/git -C $( ${ pkgs.coreutils }/bin/pwd ) rev-parse HEAD )" } &&
                    BIN_TIME=$( ${ pkgs.coreutils }/bin/date +Y%m%d%H%M%S ) &&
                    ${ pkgs.coreutils }/bin/mkdir ${ work-dir }/apply &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/apply init &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/apply config user.name "No One" &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/apply config user.email "no@one" &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/apply remote add origin ${ apply-dir } &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/apply fetch origin ${ apply-commit } &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/apply checkout ${ apply-commit } &&
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
                    ${ pkgs.gnused }/bin/sed -e "s#github:nextmoose/utils#${ work-dir }/utils#" -e "w${ work-dir }/shell/flake.nix" flake.nix &&
                    ${ pkgs.coreutils }/bin/mkdir ${ work-dir }/utils &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/utils init &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/utils config user.name "No One" &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/utils config user.email "no@one" &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/utils remote add origin $( ${ pkgs.coreutils }/bin/pwd ) &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/utils fetch origin ${ utils-commit } &&
                    ${ pkgs.git }/bin/git -C ${ work-dir }/utils checkout ${ utils-commit } &&
                    ${ pkgs.gnused }/bin/sed -e "s#github:nextmoose/argue#${ work-dir }/argue#" -e "w${ work-dir }/utils/flake.nix" ${ dollar "UTILS_HOME" }/flake.nix &&
                    ( ${ pkgs.coreutils }/bin/cat > bin/${ bin-time }.sh <<EOF
                    #!/bin/sh
                      
                    export SHELL_COMMIT=${ shell-commit } &&
                    export ARGUE_COMMIT=${ argue-commit } &&
                    export UTILS_COMMIT=${ utils-commit } &&
                    initiate ${ apply-commit } ${ argue-dir } ${ utils-commit }
                    EOF
                    ) &&
                    ${ pkgs.coreutils }/bin/chmod 0500 bin/${ bin-time } &&
                    ${ pkgs.nix }/bin/nix develop --impure ${ work-dir }/shell
                  ''
              )
            ] ;
      shellHook =
        ''
          export ARGUE_HOME=/home/emory/projects/h9QAx8XE &&
          export APPLY_HOME=/home/emory/projects/L5bpxC6n &&
          export UTILS_HOME=/home/emory/projects/MGWfXwul &&
          ${ pkgs.coreutils}/bin/echo STRUCTURE FLAKE DEVELOPMENT ENVIRONMENT
        '' ;
    }
