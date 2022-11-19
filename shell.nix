{ pkgs ? import ( fetchTarball "https://github.com/NixOS/nixpkgs/archive/bf972dc380f36a3bf83db052380e55f0eaa7dcb6.tar.gz" ) {} } :
  pkgs.mkShell
    {
      buildInputs =
        [
	  pkgs.coreutils
	  pkgs.emacs
	  pkgs.inetutils
	  (
 	    pkgs.writeShellScript
  	      "initiate"
	      ''
	        WORK_DIR=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
		cleanup ( )
		{
		  ${ pkgs.findutils }/bin/find ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] } -type f -exec ${ pkgs.coreutils }/bin/shred --force --remove {} \; &&
		  ${ pkgs.coreutils }/bin/rm --recursive --force ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }
		} &&
		trap cleanup EXIT &&
		mkdir ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }/argue &&
		${ pkgs.coreutils }/bin/cp argue/flake.nix ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }/argue &&
		${ pkgs.coreutils }/bin/chmod 0400 ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }/argue/flake.nix &&
		${ pkgs.git }/bin/git -C ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }/argue init &&
		${ pkgs.git }/bin/git -C ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }/argue config user.name "No User" &&
		${ pkgs.git }/bin/git -C ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }/argue config user.email "noone@nothing" &&
		${ pkgs.git }/bin/git -C ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }/argue checkout -b main &&
		${ pkgs.git }/bin/git -C ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }/argue add flake.nix &&
		${ pkgs.git }/bin/git -C ${ builtins.concatStringsSep "" [ "$" "{" "WORK_DIR" "}" ] }/argue commit --allow-empty-message --message "" &&
		${ pkgs.coreutils }/bin/true
	      ''
          )
	] ;
      shellHook =
        ''
	  ${ pkgs.coreutils }/bin/echo STRUCTURE FLAKE DEVELOPMENT ENVIRONMENT
	'' ;
    }
