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

REPLACEMENT="            <div class=\"release-card\">\n                <div class=\"release-header\">\n                    <a href=\"./${latest_tag}/package.dhall\" class=\"version-badge\">v${latest_tag}</a>\n                </div>\n                \n                <div class=\"import-section\">\n                    <h4>Import this version:</h4>\n                    <div class=\"import-code\">https://minaprotocol.github.io/dhall-buildkite/${latest_tag}/package.dhall ${CHECKSUM}</div>\n                </div>\n                \n                <div class=\"links-grid\">\n                    <a href=\"./${latest_tag}/changelog.md\" class=\"link-card\">\n                        <span class=\"icon\">📝</span>\n                        <span class=\"label\">Changelog</span>\n                    </a>\n                    <a href=\"./${latest_tag}/docs/package.dhall.html\" class=\"link-card\">\n                        <span class=\"icon\">📚</span>\n                        <span class=\"label\">Documentation</span>\n                    </a>\n                    <a href=\"https://github.com/MinaProtocol/dhall-buildkite/tree/${latest_tag}/examples\" class=\"link-card\">\n                        <span class=\"icon\">💡</span>\n                        <span class=\"label\">Examples</span>\n                    </a>\n                </div>\n            </div>\n            \n            <!-- Add more releases as needed -->"
sed -i "s|<!-- Add more releases as needed -->|${REPLACEMENT}|" releases/index.html