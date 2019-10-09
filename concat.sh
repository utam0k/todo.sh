#!/bin/bash
readonly FILES=("common.sh")

lines=$(grep -n source todo.sh | cut -d : -f 1)
if [ "$lines" ]; then
    for line in $lines; do
        # TODO
        sed -e "$(( line ))d" -e "$(( line - 1 ))r common.sh" todo.sh > tmp.sh
    done
else
    cp todo.sh tmp.sh
fi
