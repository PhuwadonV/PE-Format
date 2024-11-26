#!/bin/sh

SCRIPT_PATH=${0%/*}
[ -d "$SCRIPT_PATH" ] && cd "$SCRIPT_PATH"

rm -rf out
