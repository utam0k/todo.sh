#!/bin/bash

source common.sh

TARGET_FILE="./test/todo.txt"
todos=()
while IFS='' read -r line; do todos+=("$line"); done < <(sort -k 4,4 < "$TARGET_FILE")

test_include_subproject() {
    include_subproject "parent_only"
    assertEquals $? 1
    include_subproject "parent_only+sub"
    assertEquals $? 0
}

test_extract_project() {
    result=$(extract_project "- (C) 2019-10-03 todo description")
    assertEquals $? 0
    assertEquals "$result" "todo"
}

test_extract_projects() {
    # '\ n' is too difficult to handle in unit test.
    result=$(extract_projects "${todos[@]}" | tr '\n' ' ')
    assertEquals $? 0
    expect=$(echo "todo todo todo+a todo+b ")
    assertEquals "$result" "$expect"

    result=$(extract_projects "()")
    assertEquals $? 0
    expect=()
    assertEquals "$result" "$expect"
}

. ./test/shunit2
