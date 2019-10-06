#!/bin/bash

function include_subproject() {
    if echo "$1" | grep "\+" > /dev/null; then
        return 0
    else
        return 1
    fi
}
