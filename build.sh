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

mkdir -p out
CheckExitCode

nasm src/hlw.asm -f bin -o out/hlw.exe
CheckExitCode
nasm src/knl.asm -f bin -o out/knl.dll
CheckExitCode
nasm src/usr.asm -f bin -o out/usr.dll
CheckExitCode
