#!/bin/bash

source ./build/todo.sh

# TODO
# testAdd() {
#     _output=`_add`
#     assertEquals $? 0
# }

testIncludeSubproject() {
    include_subproject "parent_only"
    assertEquals $? 1
    include_subproject "parent_only+sub"
    assertEquals $? 0
}

. ./test/shunit2
