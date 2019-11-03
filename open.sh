#!/bin/bash

function _open () {
    check_is_exit_file "$TARGET_FILE"
    nvim  "$TARGET_FILE"
    return 0
}

