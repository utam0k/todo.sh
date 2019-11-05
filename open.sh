#!/bin/bash

function _open () {
    check_is_exit_file "$TARGET_FILE"
    ${EDITOR:-vi} "$TARGET_FILE"
    return 0
}

