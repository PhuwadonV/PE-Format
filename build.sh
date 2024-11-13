#!/usr/bin/env bash

SCRIPT_PATH=${0%/*}

if [ -d $SCRIPT_PATH ]; then
    cd $SCRIPT_PATH
fi

mkdir -p out

nasm src/hlw.asm -f bin -o out/hlw.exe
nasm src/knl.asm -f bin -o out/knl.dll
nasm src/usr.asm -f bin -o out/usr.dll

if [ "$?" -ne 0 ]; then
    . /etc/os-release

    case "$ID_LIKE" in
        'cygwin arch')
            printf '\nPress any key to continue\n'
            read -rs -n 1 ;;
    esac
fi
