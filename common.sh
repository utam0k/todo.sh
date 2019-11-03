#!/bin/bash

function include_subproject() {
    if echo "$1" | grep "\+" > /dev/null; then
        return 0
    else
        return 1
    fi
}

function check_is_exit_file() {
    if [ ! -e "$1" ]; then
        echo "[Error] Not found $1" >&2
        exit 1
    fi
}
