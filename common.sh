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

function extract_project() {
    echo "$1" | awk '{ print $4 }'
    return $?
}

function extract_projects() {
    args=("$@")
    ret=""
    for t in "${args[@]}"; do
        ret+="$(extract_project "$t")\n"
    done
    printf "%b" "$ret"
    return 0
}
