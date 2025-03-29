#!/bin/bash

# filepath: /home/darek/work/minaprotocol/dhall-base/release/dhall-to-html.sh

# Check if a file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <dhall-file>"
    exit 1
fi

# Input Dhall file
dhall_file="$1"

# Output HTML file
output_file="${dhall_file%.dhall}.html"

# Function to convert paths to clickable links
convert_paths_to_links() {
    sed -E 's|(../../[^\s]+)|<a href="\1">\1</a>|g'
}

# Generate HTML content using the template
{
    echo '<!DOCTYPE html>'
    echo '<html lang="en">'
    echo '<head>'
    echo '    <meta charset="UTF-8">'
    echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">'
    echo '    <title>Dhall File Viewer</title>'
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
    echo '    </style>'
    echo '</head>'
    echo '<body>'
    echo '    <header>'
    echo '        <img src="https://avatars.githubusercontent.com/u/31601797?s=200&v=4" alt="Logo">'
    echo '        <h1>Dhall File Viewer</h1>'
    echo '    </header>'
    echo '    <nav>'
    echo '        <a href="/">/</a>'
    echo "        <a href=\"/$(basename "$(dirname "$dhall_file")")\">$(basename "$(dirname "$dhall_file")")</a>"
    echo "        <a href=\"/$dhall_file\">$(basename "$dhall_file")</a>"
    echo '    </nav>'
    echo '    <main>'
    echo '        <h2>Source</h2>'
    echo '        <pre>'
    cat "$dhall_file" | convert_paths_to_links
    echo '        </pre>'
    echo '    </main>'
    echo '    <footer>'
    echo '        <p>&copy; 2025 Dhall File Viewer</p>'
    echo '    </footer>'
    echo '</body>'
    echo '</html>'
} > "$output_file"

echo "HTML file generated: $output_file"