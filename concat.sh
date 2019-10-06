#!/bin/bash
readonly FILES=("test/test.sh")

lines=$(grep -n source todo.sh | cut -d : -f 1 | xargs echo | sed -e 's/ /,/g')
if [ "$lines" ]; then
    sed "$(( lines ))d" todo.sh > tmp.sh
fi

for file in "${FILES[@]}"; do
    cat "$file" >> tmp.sh
done
