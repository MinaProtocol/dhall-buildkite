#!/bin/bash

# This script needs to be executed at the root of the project



# Clear the output file if it exists
counter=1

# Get the latest GitHub tag
latest_tag=$(git describe --tags $(git rev-list --tags --max-count=1))

echo "Latest GitHub tag: $latest_tag"

mkdir -p releases/$latest_tag/docs

cp release/template/index.html releases/index.html
cp release/template/changelog.md releases/$latest_tag/changelog.md
cp -R src releases/$latest_tag/src

output_file="releases/$latest_tag/package.dhall"


for file in $(find src -type f -name "*.dhall"); do
    filename=$(basename "$file" .dhall)
    filepath=$(dirname "$file" | sed 's|^src/||')
    import=$(echo "$filepath" | tr '/' '.')

    if [[ $counter -eq 1 ]]; then
      prefix="{"
    else 
      prefix=","
    fi

    echo "$prefix $import.$filename = (./$file)" >> "$output_file"

    ./dhall-to-html.sh "$file" > "releases/$latest_tag/docs/$filepath.$filename.html"
    
    cp "$file" "releases/$latest_tag/$filepath/$filename.dhall"


    

    ((counter++))
done
echo "}" >> "$output_file"

CHECKSUM=$(sha256sum "$output_file" | awk '{print $1}')

echo ls --recursive releases

echo "Generated $output_file with checksum $CHECKSUM"

echo "Release $latest_tag is ready to be published"

REPLACEMENT="<li>\n<a href=\"./${latest_tag}/package.dhall\">${latest_tag}/package.dhall</a>\n<p>Import this version with:</p>\n<pre><code>https://minaprotocol.github.io/dhall-base/${latest_tag}/package.dhall sha256:${CHECKSUM}</code></pre>\n<p>\n<a href=\"./${latest_tag}/changelog.md\"> Changelog for ${latest_tag} version </a>\n</li>\n<!-- Add more releases as needed -->"
sed -i "s|<!-- Add more releases as needed -->|${REPLACEMENT}|" releases/index.html