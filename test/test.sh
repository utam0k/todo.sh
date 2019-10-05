#!/bin/bash

source ./todo.sh

testAdd() {
  _output=`_add`
  assertEquals $? 0
}

# shUnit2 は最後に読み込んであげる必要がある
. ./test/shunit2
