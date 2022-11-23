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
                    ${ pkgs.git }/bin/git -C ${ dollar "SCRIPT_HOME" } commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }" &&
                    ${ pkgs.git }/bin/git -C ${ dollar "SHELL_HOME" } commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }" &&
                    ${ pkgs.git }/bin/git -C ${ dollar "TRY_HOME" } commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }" &&
                    ${ pkgs.git }/bin/git -C ${ dollar "VISIT_HOME" } commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }" &&
                    ${ pkgs.git }/bin/git -C ${ dollar "UTILS_HOME" } commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }" &&
                    ${ pkgs.git }/bin/git commit --all --allow-empty --allow-empty-message --message "${ dollar "@" }"
                  ''
              )
              (
                pkgs.writeShellScriptBin
                  "edit"
                  ''
                    ${ pkgs.emacs }/bin/emacs \
                      shell.nix \
                      flake.nix \
                      ${ dollar "APPLY_HOME" }/flake.nix \
                      ${ dollar "ARGUE_HOME" }/flake.nix \
                      ${ dollar "SCRIPT_HOME" }/flake.nix \
                      ${ dollar "SHELL_HOME" }/flake.nix \
                      ${ dollar "TRY_HOME" }/flake.nix \
                      ${ dollar "UTILS_HOME" }/flake.nix \
                      ${ dollar "VISIT_HOME" }/flake.nix \
                      &
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
                          ${ pkgs.git }/bin/git -C ${ dollar "SCRIPT_HOME" } commit --all --allow-empty --message "TESTED" &&
                          ${ pkgs.git }/bin/git -C ${ dollar "SHELL_HOME" } commit --all --allow-empty --message "TESTED" &&
                          ${ pkgs.git }/bin/git -C ${ dollar "TRY_HOME" } commit --all --allow-empty --message "TESTED" &&
                          ${ pkgs.git }/bin/git -C ${ dollar "UTIL_HOME" } commit --all --allow-empty --message "TESTED" &&
                          ${ pkgs.git }/bin/git -C ${ dollar "VISIT_HOME" } commit --all --allow-empty --message "TESTED" &&
                          ${ pkgs.git }/bin/git commit --all --allow-empty --message "TESTED"
                          ${ pkgs.coreutils }/bin/rm --recursive --force ${ work-dir }
                        else
                          ${ pkgs.coreutils }/bin/echo There was a problem with ${ work-dir } - ${ dollar "?" }
                        fi
                    } &&
                    trap cleanup EXIT &&
                    ${ pkgs.git }/bin/git -C ${ dollar "APPLY_HOME" } commit --all --allow-empty --allow-empty-message --message "" &&
                    APPLY_COMMIT=${ dollar "APPLY_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ dollar "APPLY_HOME" } rev-parse HEAD )" } &&
                    ${ pkgs.git }/bin/git -C ${ dollar "ARGUE_HOME" } commit --all --allow-empty --allow-empty-message --message "" &&
                    ARGUE_COMMIT=${ dollar "ARGUE_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ dollar "ARGUE_HOME" } rev-parse HEAD )" } &&
                    ${ pkgs.git }/bin/git -C ${ dollar "SCRIPT_HOME" } commit --all --allow-empty --allow-empty-message --message "" &&
                    SCRIPT_COMMIT=${ dollar "SCRIPT_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ dollar "SCRIPT_HOME" } rev-parse HEAD )" } &&
                    ${ pkgs.git }/bin/git -C ${ dollar "SHELL_HOME" } commit --all --allow-empty --allow-empty-message --message "" &&
                    SHELL_COMMIT=${ dollar "SHELL_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ dollar "SHELL_HOME" } rev-parse HEAD )" } &&
                    ${ pkgs.git }/bin/git -C ${ dollar "TRY_HOME" } commit --all --allow-empty --allow-empty-message --message "" &&
                    TRY_COMMIT=${ dollar "TRY_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ dollar "TRY_HOME" } rev-parse HEAD )" } &&
                    ${ pkgs.git }/bin/git -C ${ dollar "UTILS_HOME" } commit --all --allow-empty --allow-empty-message --message "" &&
                    UTILS_COMMIT=${ dollar "UTILS_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ dollar "UTILS_HOME" } rev-parse HEAD )" } &&
                    ${ pkgs.git }/bin/git -C ${ dollar "VISIT_HOME" } commit --all --allow-empty --allow-empty-message --message "" &&
                    VISIT_COMMIT=${ dollar "VISIT_COMMIT:=$( ${ pkgs.git }/bin/git -C ${ dollar "VISIT_HOME" } rev-parse HEAD )" } &&
                    function checkout ( )
                    {
                      NAME=${ dollar "1" } &&
                      DIR=${ dollar "2" } &&
                      COMMIT=${ dollar "3" } &&
                      ${ pkgs.coreutils }/bin/mkdir ${ work-dir }/${ dollar "NAME" } &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/${ dollar "NAME" } init &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/${ dollar "NAME" } config user.name "No One" &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/${ dollar "NAME" } config user.email "no@one" &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/${ dollar "NAME" } remote add origin ${ dollar "DIR" } &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/${ dollar "NAME" } fetch origin ${ dollar "COMMIT" } &&
                      ${ pkgs.git }/bin/git -C ${ work-dir }/${ dollar "NAME" } checkout ${ dollar "COMMIT" } &&
                      ${ pkgs.gnused }/bin/sed \
                        -e "s#github:nextmoose/apply#${ work-dir }/apply#" \
                        -e "s#github:nextmoose/argue#${ work-dir }/argue#" \
                        -e "s#github:nextmoose/script#${ work-dir }/script#" \
                        -e "s#github:nextmoose/shell#${ work-dir }/shell#" \
                        -e "s#github:nextmoose/try#${ work-dir }/try#" \
                        -e "s#github:nextmoose/utils#${ work-dir }/utils#" \
                        -e "s#github:nextmoose/visit#${ work-dir }/visit#" \
                        -e "w${ work-dir }/${ dollar "NAME" }/flake.nix" \
                        flake.nix
                    } &&
                    checkout argue ${ dollar "ARGUE_HOME" } ${ dollar "ARGUE_COMMIT" } ${ dollar "WORK_DIR" } &&
                    checkout apply ${ dollar "APPLY_HOME" } ${ dollar "APPLY_COMMIT" } ${ dollar "WORK_DIR" } &&
                    checkout script ${ dollar "SCRIPT_HOME" } ${ dollar "SCRIPT_COMMIT" } ${ dollar "WORK_DIR" } &&
                    checkout shell ${ dollar "SHELL_HOME" } ${ dollar "SHELL_COMMIT" } ${ dollar "WORK_DIR" } &&
                    checkout try ${ dollar "TRY_HOME" } ${ dollar "TRY_COMMIT" } ${ dollar "WORK_DIR" } &&
                    checkout utils ${ dollar "UTILS_HOME" } ${ dollar "UTILS_COMMIT" } ${ dollar "WORK_DIR" } &&
                    checkout visit ${ dollar "VISIT_HOME" } ${ dollar "VISIT_COMMIT" } ${ dollar "WORK_DIR" } &&
                    ( ${ pkgs.coreutils }/bin/cat > bin/${ bin-time }.sh <<EOF
                    #!/bin/sh
                      
                    export ARGUE_COMMIT=${ dollar "ARGUE_COMMIT" } &&
                    export APPLY_COMMIT=${ dollar "APPLY_COMMIT" } &&
                    export SHELL_COMMIT=${ dollar "SHELL_COMMIT" } &&
                    export TRY_COMMIT=${ dollar "TRY_COMMIT" } &&
                    export UTILS_COMMIT=${ dollar "UTILS_COMMIT" } &&
                    export VISIT_COMMIT=${ dollar "VISIT_COMMIT" } &&
                    initiate
                    EOF
                    ) &&
                    ${ pkgs.coreutils }/bin/chmod 0500 bin/${ bin-time }.sh &&
                    ${ pkgs.nix }/bin/nix develop --impure ${ work-dir }/shell
                  ''
              )
            ] ;
      shellHook =
        ''
          export ARGUE_HOME=/home/emory/projects/h9QAx8XE &&
          export APPLY_HOME=/home/emory/projects/L5bpxC6n &&
          export SHELL_HOME=/home/emory/projects/4GBaUR7F &&
	  export SCRIPT_HOME=/home/emory/projects/71tspv3q &&
          export TRY_HOME=/home/emory/projects/0gG3HgHu &&
          export UTILS_HOME=/home/emory/projects/MGWfXwul &&
          export VISIT_HOME=/home/emory/projects/wHpYNJk8 &&
          ${ pkgs.coreutils }/bin/echo STRUCTURE FLAKE DEVELOPMENT ENVIRONMENT
        '' ;
    }
