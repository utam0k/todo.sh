#!/bin/bash

function include_subproject() {
    if echo "$1" | grep "\+" > /dev/null; then
        return 0
    else
        return 1
    fi
}

function alert() {
    printf "\e[31m[Error]\e[m"
    return 0
}

function warn() {
    printf "\e[33m[Warn]\e[m" >&2
    return 0
}

function check_is_exit_file() {
    if [ ! -e "$1" ]; then
        printf "$(alert) Not found %s\n" "$1" >&2
        exit 1
    fi
}
