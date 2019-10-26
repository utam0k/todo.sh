#!/bin/bash

readonly PLUGINS_FILE="tmp_plugins.sh"

if [ -e "$PLUGINS_FILE" ]; then
    rm "$PLUGINS_FILE"
fi

plugins=$(find plugins -type f -print | sed 's#.*/##' | sed 's/\.sh//')
echo "plugins=()" >> "$PLUGINS_FILE"

# generate plugins file.
for p in $plugins; do
    echo "plugins+=($p)" >> "$PLUGINS_FILE"
    echo "source plugins/$p.sh" >> "$PLUGINS_FILE"
done
