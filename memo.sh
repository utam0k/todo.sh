#!/bin/bash

source common.sh

function _memo() {
    todos=()
    while IFS='' read -r line; do todos+=("$line"); done < <(_ls)
    if [ "$#" -ne 1 ]; then
        _ls
        read -r n
    else
        n="$1"
    fi

    todoname=$(echo "${todos[$n]}" | awk '{print $5}')
    nvim "$TARGET_FOLDER/$todoname.md"
    return 0
}
