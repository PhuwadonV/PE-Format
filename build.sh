#!/bin/sh

SCRIPT_PATH=${0%/*}
[ -d "$SCRIPT_PATH" ] && cd "$SCRIPT_PATH"

. /etc/os-release
OS_ID_LIKE="$ID_LIKE"

OnError()
{
    case "$OS_ID_LIKE" in
        'cygwin arch')
            printf '\nPress any key to continue\n'
            read -rs -n 1
            exit $? ;;
    esac
}

mkdir -p out || OnError

nasm src/hlw.asm -i src -f bin -o out/hlw.exe || OnError
nasm src/knl.asm -i src -f bin -o out/knl.dll || OnError
nasm src/usr.asm -i src -f bin -o out/usr.dll || OnError
