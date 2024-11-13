#!/usr/bin/env bash

SCRIPT_PATH=${0%/*}

if [ -d $SCRIPT_PATH ]; then
    cd $SCRIPT_PATH
fi

rm -r out
