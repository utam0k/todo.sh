#!/bin/bash

readonly BUILD_DIR="$1"
readonly PLUGINS_FILE="$BUILD_DIR/$2"

if [ ! -d "$BUILD_DIR" ]; then
    mkdir -p "$BUILD_DIR"
fi

if [ -e "$PLUGINS_FILE" ]; then
    rm "$PLUGINS_FILE"
fi

plugins=$(find plugins -type f -print | sed 's#.*/##' | sed 's/\.sh//')
echo "plugins=()" >> "$PLUGINS_FILE"

# generate plugins file.
for p in $plugins; do
    echo "plugins+=(\"$p\")" >> "$PLUGINS_FILE"
    echo "source plugins/$p.sh" >> "$PLUGINS_FILE"
done
