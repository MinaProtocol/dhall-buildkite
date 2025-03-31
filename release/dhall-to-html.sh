#!/bin/bash

# Check if a file is provided
if [ "$#" -ne 5 ]; then
    echo "This script generates an HTML file from a Dhall file."
    echo "The HTML file will be saved in the specified output directory."
    echo "The paths in the Dhall file will be converted to clickable links."
    echo
    echo "Usage: $0 <dhall-file> <html-file> <package_version> <root-dir>"
    echo "Example: $0 src/example.dhall output.html docs"
    exit 1
fi

# Input Dhall file
dhall_file="$1"

# Output HTML file
output_file="$2"

# Root directory for the HTML files
package_name="$3"

package_version="$4"

root_dir="$5"

# Function to convert paths to clickable links
convert_paths_to_links() {
    sed -E 's|=\ (\..*\.dhall)|= <a href="\1.html">\1</a>|g'
}

# Function to highlight Dhall reserved keywords
highlight_keywords() {
    sed -E \
        -e 's/\b(let|in|if|then|else|None|Some|Optional|Text|Natural|Integer|Bool|True|False)\b/<span style="color: #d73a49; font-weight: bold;">\1<\/span>/g'
}

# Extract only top comments (lines starting with '--' at the top of the file)
extract_top_comments() {
    inside_comment_block=false
    while IFS= read -r line; do
        if [[ $line == "{-|"* ]]; then
            inside_comment_block=true
            continue
        elif [[ $line == "-}"* ]]; then
            inside_comment_block=false
            continue
        fi

        if $inside_comment_block; then
            if [[ $line == \#\#\#\#* ]]; then
                # Convert lines starting with ### to <h5>
                echo "$line" | sed 's/^####\(.*\)/<h6>\1<\/h6>/'
            elif [[ $line == \#\#\#* ]]; then
                # Convert lines starting with ### to <h5>
                echo "$line" | sed 's/^###\(.*\)/<h5>\1<\/h5>/'
            elif [[ $line == \#\#* ]]; then
                # Convert lines starting with ## to <h4>
                echo "$line" | sed 's/^##\(.*\)/<h4>\1<\/h4>/'
            elif [[ $line == \#* ]]; then
                # Convert lines starting with # to <h3>
                echo "$line" | sed 's/^#\(.*\)/<h3>\1<\/h3>/'
            elif [[ -z $line ]]; then
                # If the line is empty, do not print anything
                continue
            else
              # Remove leading '--' and trim whitespace
                echo "$line </br>" | sed 's/-- //g' | sed 's/--//g' | sed 's/^\s*//g' | sed 's/\s*$//g'
            fi
        fi
    done < "$dhall_file"
}

# Remove top comments from the Dhall file content
remove_top_comments() {
    sed '/{-|/,/-}/d' "$dhall_file"
}

# Generate HTML content using the template
{
    echo '<!DOCTYPE html>'
    echo '<html lang="en">'
    echo '<head>'
    echo '    <meta charset="UTF-8">'
    echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
    echo '    <title>Dhall Documentation</title>'
    echo '    <style>'
    echo '        body { font-family: Arial, sans-serif; line-height: 1.6; background-color: #f9f9f9; color: #333; margin: 0; padding: 0; }'
    echo '        header { background-color: #222; color: white; padding: 10px 20px; display: flex; align-items: center; }'
    echo '        header img { height: 40px; margin-right: 15px; }'
    echo '        header h1 { margin: 0; font-size: 1.5rem; }'
    echo '        nav { margin: 10px 20px; font-size: 0.9rem; }'
    echo '        nav a { color: #007BFF; text-decoration: none; margin-right: 5px; }'
    echo '        nav a:hover { text-decoration: underline; }'
    echo '        main { padding: 20px; }'
    echo '        h2 { border-bottom: 2px solid #ddd; padding-bottom: 5px; margin-bottom: 15px; font-size: 1.2rem; }'
    echo '        pre { background-color: #f4f4f4; padding: 15px; border: 1px solid #ddd; border-radius: 5px; overflow-x: auto; font-family: "Courier New", Courier, monospace; }'
    echo '        footer { background-color: #222; color: white; text-align: center; padding: 10px 0; margin-top: 20px; }'
    echo '        footer p { margin: 0; font-size: 0.9rem; }'
    echo '        span { font-weight: bold; }'
    echo '    </style>'
    echo '</head>'
    echo '<body>'
    echo '    <header>'
    echo '        <img src="https://avatars.githubusercontent.com/u/31601797?s=200&v=4" alt="Logo">'
    if [ "$(basename "$(dirname "$dhall_file")")" != "$package_version" ]; then
        echo "        <h1> <a href=\"$root_dir/index.html\">$package_name</a> / <a href=\"$root_dir/$package_version/docs/package.dhall.html\">$package_version</a> / $(basename "$(dirname "$dhall_file")") / $(basename "$dhall_file")</h1>"
    else
        echo "        <h1> <a href=\"$root_dir/index.html\">$package_name</a> / <a href=\"$root_dir/$package_version/docs/package.dhall.html\">$package_version</a> / $(basename "$dhall_file")</h1>"
    fi
    echo '    </header>'
    echo '    <main>'
    
    # Add extracted top comments above the source code if they exist
    comments=$(extract_top_comments)
    if [ -n "$comments" ]; then
        echo '        <section>'
        echo '            <h2>Description</h2>'
        echo "            ${comments}"
        echo '        </section>'
    fi

    echo '        <h2>Source</h2>'
    echo '        <pre>'
    remove_top_comments | convert_paths_to_links | highlight_keywords
    echo '        </pre>'
    echo '    </main>'
    echo '    <footer>'
    echo '        <p>&copy; 2025 Dhall Documentation Viewer</p>'
    echo '    </footer>'
    echo '</body>'
    echo '</html>'
} > "$output_file"

echo "HTML file generated: $output_file"