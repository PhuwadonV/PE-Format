#!/usr/bin/env bash

SCRIPT_PATH=${0%/*}

if [ -d $SCRIPT_PATH ]; then
    cd $SCRIPT_PATH
fi

. /etc/os-release
OS_ID_LIKE="$ID_LIKE"

CheckExitCode()
{
    if [ "$?" -ne 0 ]; then
        case "$OS_ID_LIKE" in
            'cygwin arch')
                printf '\nPress any key to continue\n'
                read -rs -n 1
                exit $? ;;
        esac
    fi
}

rm -rf out
CheckExitCode
