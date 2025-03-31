#!/bin/bash

# This script needs to be executed at the root of the project   

PACKAGE_FILE=out/package.dhall
HASH_FILE=out/package.dhall.hash

if [[ ! -f $PACKAGE_FILE ]]; then
    echo "Error: out/package.dhall does not exist."
    exit 1
fi
if [[ ! -f $HASH_FILE ]]; then
    echo "Error: out/package.dhall.hash does not exist."
    exit 1
fi

find examples -type f -name "Base.dhall" | while read -r file; do
    cp "$file" "$file.bak"

    echo "../../../../$PACKAGE_FILE $(cat $HASH_FILE)" > "$file"
    
    if [[ $? -ne 0 ]]; then
        echo "Error: dhall-to-yaml failed for $file"
        exit 1
    fi
done

echo "All examples have been updated with the new package.dhall reference."

echo "Reverting changes to the original files..."
find examples -type f -name "Base.dhall.bak" | while read -r file; do
    mv "$file" "${file%.bak}"
    
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to revert changes for $file"
        exit 1
    fi
done
echo "All examples have been reverted to their original state."