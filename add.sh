#!/bin/bash

source common.sh

function _add() {
    if command [ "$#" -ne 3 ]; then
        return 1
    fi

    # TODO: Define format function and tests.
    echo "- ($1) $(date +"%Y-%m-%d") $2 $3" >> "TARGET_FILE"
    return 0
}

