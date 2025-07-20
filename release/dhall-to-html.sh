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
    echo '    <title>Dhall Documentation - '$package_name'</title>'
    echo '    <link rel="icon" type="image/png" href="https://minaprotocol.com/wp-content/uploads/Favicon-4x.png">'
    echo '    <style>'
    echo '        * { margin: 0; padding: 0; box-sizing: border-box; }'
    echo '        body {'
    echo '            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;'
    echo '            line-height: 1.6;'
    echo '            color: #333;'
    echo '            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);'
    echo '            min-height: 100vh;'
    echo '        }'
    echo '        .container { max-width: 1200px; margin: 0 auto; padding: 2rem; }'
    echo '        header {'
    echo '            background: rgba(255, 255, 255, 0.95);'
    echo '            backdrop-filter: blur(10px);'
    echo '            border-radius: 20px;'
    echo '            padding: 2rem;'
    echo '            margin-bottom: 2rem;'
    echo '            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);'
    echo '        }'
    echo '        .header-content { display: flex; align-items: center; gap: 1rem; flex-wrap: wrap; }'
    echo '        .logo { width: 50px; height: 50px; object-fit: contain; }'
    echo '        .breadcrumb {'
    echo '            flex: 1;'
    echo '            font-size: 1.1rem;'
    echo '            color: #666;'
    echo '        }'
    echo '        .breadcrumb a {'
    echo '            color: #667eea;'
    echo '            text-decoration: none;'
    echo '            font-weight: 500;'
    echo '            transition: color 0.3s ease;'
    echo '        }'
    echo '        .breadcrumb a:hover { color: #764ba2; }'
    echo '        .breadcrumb .separator { margin: 0 0.5rem; color: #999; }'
    echo '        main {'
    echo '            background: rgba(255, 255, 255, 0.95);'
    echo '            backdrop-filter: blur(10px);'
    echo '            border-radius: 20px;'
    echo '            padding: 2rem;'
    echo '            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);'
    echo '        }'
    echo '        .section { margin-bottom: 2rem; }'
    echo '        .section h2 {'
    echo '            font-size: 1.8rem;'
    echo '            font-weight: 600;'
    echo '            color: #333;'
    echo '            margin-bottom: 1rem;'
    echo '            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);'
    echo '            -webkit-background-clip: text;'
    echo '            -webkit-text-fill-color: transparent;'
    echo '            background-clip: text;'
    echo '        }'
    echo '        .description {'
    echo '            background: #2d3748;'
    echo '            border: 1px solid #4a5568;'
    echo '            border-radius: 12px;'
    echo '            padding: 1.5rem;'
    echo '            margin-bottom: 1.5rem;'
    echo '            color: #e2e8f0;'
    echo '        }'
    echo '        .description h3, .description h4, .description h5, .description h6 {'
    echo '            color: #81e6d9;'
    echo '            margin: 1rem 0 0.5rem 0;'
    echo '            font-weight: 600;'
    echo '        }'
    echo '        .description h3:first-child, .description h4:first-child,'
    echo '        .description h5:first-child, .description h6:first-child { margin-top: 0; }'
    echo '        .description p {'
    echo '            color: #e2e8f0;'
    echo '            line-height: 1.6;'
    echo '        }'
    echo '        .code-container {'
    echo '            background: #2d3748;'
    echo '            border-radius: 12px;'
    echo '            overflow: hidden;'
    echo '            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);'
    echo '        }'
    echo '        .code-header {'
    echo '            background: #1a202c;'
    echo '            padding: 0.8rem 1.2rem;'
    echo '            border-bottom: 1px solid #4a5568;'
    echo '            display: flex;'
    echo '            align-items: center;'
    echo '            gap: 0.5rem;'
    echo '        }'
    echo '        .code-header .icon { width: 12px; height: 12px; border-radius: 50%; }'
    echo '        .code-header .red { background: #f56565; }'
    echo '        .code-header .yellow { background: #ed8936; }'
    echo '        .code-header .green { background: #48bb78; }'
    echo '        .code-header .title { color: #e2e8f0; font-size: 0.9rem; margin-left: 0.5rem; }'
    echo '        pre {'
    echo '            background: transparent;'
    echo '            color: #e2e8f0;'
    echo '            padding: 1.5rem;'
    echo '            margin: 0;'
    echo '            overflow-x: auto;'
    echo '            font-family: "Monaco", "Menlo", "Ubuntu Mono", monospace;'
    echo '            font-size: 0.9rem;'
    echo '            line-height: 1.5;'
    echo '        }'
    echo '        pre a { color: #81e6d9; text-decoration: underline; }'
    echo '        pre a:hover { color: #b2f5ea; }'
    echo '        span[style*="color: #d73a49"] { color: #f56565 !important; }'
    echo '        footer {'
    echo '            background: rgba(255, 255, 255, 0.9);'
    echo '            backdrop-filter: blur(10px);'
    echo '            border-radius: 15px;'
    echo '            text-align: center;'
    echo '            padding: 1.5rem;'
    echo '            margin-top: 2rem;'
    echo '            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);'
    echo '        }'
    echo '        footer p { color: #666; font-size: 0.9rem; }'
    echo '        @media (max-width: 768px) {'
    echo '            .container { padding: 1rem; }'
    echo '            header, main { padding: 1.5rem; }'
    echo '            .header-content { flex-direction: column; text-align: center; }'
    echo '            .breadcrumb { text-align: center; }'
    echo '        }'
    echo '    </style>'
    echo '</head>'
    echo '<body>'
    echo '    <div class="container">'
    echo '        <header>'
    echo '            <div class="header-content">'
    echo '                <img src="https://minaprotocol.com/wp-content/uploads/Favicon-4x.png" alt="Mina Protocol" class="logo">'
    echo '                <div class="breadcrumb">'
    if [ "$(basename "$(dirname "$dhall_file")")" != "$package_version" ]; then
        echo "                    <a href=\"$root_dir/index.html\">$package_name</a>"
        echo "                    <span class=\"separator\">/</span>"
        echo "                    <a href=\"$root_dir/$package_version/docs/package.dhall.html\">$package_version</a>"
        echo "                    <span class=\"separator\">/</span>"
        echo "                    <span>$(basename "$(dirname "$dhall_file")")</span>"
        echo "                    <span class=\"separator\">/</span>"
        echo "                    <span>$(basename "$dhall_file")</span>"
    else
        echo "                    <a href=\"$root_dir/index.html\">$package_name</a>"
        echo "                    <span class=\"separator\">/</span>"
        echo "                    <a href=\"$root_dir/$package_version/docs/package.dhall.html\">$package_version</a>"
        echo "                    <span class=\"separator\">/</span>"
        echo "                    <span>$(basename "$dhall_file")</span>"
    fi
    echo '                </div>'
    echo '            </div>'
    echo '        </header>'
    echo '        <main>'
    
    # Add extracted top comments above the source code if they exist
    comments=$(extract_top_comments)
    if [ -n "$comments" ]; then
        echo '            <div class="section">'
        echo '                <h2>📝 Description</h2>'
        echo '                <div class="description">'
        echo "                    ${comments}"
        echo '                </div>'
        echo '            </div>'
    fi

    echo '            <div class="section">'
    echo '                <h2>📄 Source Code</h2>'
    echo '                <div class="code-container">'
    echo '                    <div class="code-header">'
    echo '                        <div class="icon red"></div>'
    echo '                        <div class="icon yellow"></div>'
    echo '                        <div class="icon green"></div>'
    echo '                        <div class="title">'"$(basename "$dhall_file")"'</div>'
    echo '                    </div>'
    echo '                    <pre>'
    remove_top_comments | convert_paths_to_links | highlight_keywords
    echo '                    </pre>'
    echo '                </div>'
    echo '            </div>'
    echo '        </main>'
    echo '        <footer>'
    echo '            <p>💜 Built with love for the Mina Protocol community | &copy; 2025 MinaProtocol Dhall Documentation</p>'
    echo '        </footer>'
    echo '    </div>'
    echo '</body>'
    echo '</html>'
} > "$output_file"

echo "HTML file generated: $output_file"