#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in	
	--resource-directory)
	    RESOURCE_DIRECTORY=${2} &&
		shift 2 &&
	    ;;
	*)
	    echo UNEXPECTED &&
		echo ${@} &&
		exit 64
	    ;;
    esac
done &&
    RESOURCE_DIRECTORY=${RESOURCE_DIRECTORY:=$( mktemp --directory )} &&
    SOURCE_DIRECTORY=$( mktemp --directory ) &&
    cp ${GENERATE} ${SOURCE_DIRECTORY} &&
    chmod 0400 ${SOURCE_DIRECTORY}/flake.nix &&
    echo ${SOURCE_DIRECTORY)
