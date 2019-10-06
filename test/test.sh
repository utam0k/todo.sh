#!/bin/bash

source ./tmp.sh

testAdd() {
  _output=`_add`
  assertEquals $? 0
}

. ./test/shunit2
