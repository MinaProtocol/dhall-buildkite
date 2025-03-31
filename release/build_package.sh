#!/bin/bash

output_folder=$1

PACKAGE_FILE="$output_folder/package.dhall"

if [ -z "$output_folder" ]; then
    echo "Usage: $0 <output_folder>"
    exit 1
fi

# Check if the output file already exists
if [ -f "$output_folder" ]; then
    echo "WARN: $output_folder already exists. removing it."
    rm -f "$output_folder"
fi

echo "Generating $PACKAGE_FILE"
mkdir -p "$output_folder"
counter=1

for file in $(find src -type f -name "*.dhall"); do
    filename=$(basename "$file" .dhall)
    filepath=$(dirname "$file" | sed 's|^src/||')
    import=$(echo "$filepath" | tr '/' '.')

    if [[ $counter -eq 1 ]]; then
      prefix="{"
    else 
      prefix=","
    fi

    echo "$prefix $import.$filename = ./$file" >> "$PACKAGE_FILE"

    ((counter++))
done
echo "}" >> "$PACKAGE_FILE"

HASH=$(dhall hash < $PACKAGE_FILE)

echo $HASH > "$PACKAGE_FILE.hash"

mkdir -p out

cp -R src out

echo "Generated $PACKAGE_FILE with checksum $(cat $PACKAGE_FILE.hash)"
echo "Checksum saved to $PACKAGE_FILE.hash"
