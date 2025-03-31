#!/bin/bash

# This script needs to be executed at the root of the project

page_root="https://s3.us-west-2.amazonaws.com/dhall.packages.minaprotocol.com/buildkite/releases"

# Clear the output file if it exists
counter=1

package_name="dhall-buildkite"

# Get the latest GitHub tag
latest_tag=$(git describe --tags $(git rev-list --tags --max-count=1))

echo "Latest GitHub tag: $latest_tag"

# Copy files

rm -rf releases/$latest_tag
mkdir -p releases/$latest_tag/docs

cp release/template/index.html releases/index.html
cp release/template/changelog.md releases/$latest_tag/changelog.md

cp -R out/src releases/$latest_tag/src


output_file="releases/$latest_tag/package.dhall"

# Generate documentation  

for file in $(find src -type f -name "*.dhall"); do
    filename=$(basename "$file" .dhall)
    filepath=$(dirname "$file" | sed 's|^src/||')

    mkdir -p releases/$latest_tag/docs/src/$filepath
    
    ./release/dhall-to-html.sh "$file" "releases/$latest_tag/docs/src/$filepath/$filename.dhall.html" "$package_name" "$latest_tag" $page_root
    
    ((counter++))
done

cp out/package.dhall "$output_file"

./release/dhall-to-html.sh "$output_file" "releases/$latest_tag/docs/package.dhall.html" "$package_name" "$latest_tag" $page_root

CHECKSUM=$(cat out/package.dhall.hash)

# Target examples to http import
find examples -type f -name "Base.dhall" | while read -r file; do
    echo "${page_root}/${latest_tag}/package.dhall ${CHECKSUM}" > "$file"
    
    if [[ $? -ne 0 ]]; then
        echo "Error: update failed for $file"
        exit 1
    fi
done

echo "Release $latest_tag is ready to be published"

REPLACEMENT="<li>\n<a href=\"./${latest_tag}/package.dhall\">${latest_tag}/package.dhall</a>\n<p>Import this version with:</p>\n<pre><code>https://minaprotocol.github.io/dhall-buildkite/${latest_tag}/package.dhall ${CHECKSUM}</code></pre>\n<p>\n<p><a href=\"./${latest_tag}/changelog.md\"> Changelog </a></p>\n<p><a href=\"./${latest_tag}/docs/package.dhall.html\"> Documentation </a></p>\n \n<p><a href=\"https://github.com/MinaProtocol/dhall-buildkite/blob/main/examples/${latest_tag}\"> Examples </a></p>\n</li>\n<!-- Add more releases as needed -->"
sed -i "s|<!-- Add more releases as needed -->|${REPLACEMENT}|" releases/index.html