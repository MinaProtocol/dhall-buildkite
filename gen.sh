#!/bin/bash

# This script needs to be executed at the root of the project

mkdir -p out

output_file="out/Base.dhall"

# Clear the output file if it exists
> "$output_file"

counter=1

for file in $(find src -type f -name "*.dhall"); do
    filename=$(basename "$file" .dhall)
    filepath=$(dirname "$file" | sed 's|^src/||')
    
    if [[ $counter -eq 1 ]]; then
      prefix="{"
    else 
      prefix=","
    fi

    echo "$prefix $filepath/$filename = (./$file)" >> "$output_file"
    
    ((counter++))
done
echo "}" >> "$output_file"

CHECKSUM=$(sha256sum "$output_file" | awk '{print $1}')

echo "Generated $output_file with checksum $CHECKSUM"

