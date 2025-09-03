#!/bin/bash
# Remote Tera PKG installer

TITLE="Tera dox v0.01"
REPO_URL="https://raw.githubusercontent.com/lucent-hub/Lucent/main/Extra/UI/A/H/H/Tera.js"
PKG_NAME="ter"
BIN_DIR="$HOME/bin"

mkdir -p "$BIN_DIR"

# Create the CLI script
cat <<'EOF' > "$BIN_DIR/$PKG_NAME"
#!/bin/bash
TITLE="Tera dox v0.01"
FILE_NAME="Tera.js"
REPO_URL="https://raw.githubusercontent.com/lucent-hub/Lucent/main/Extra/UI/A/H/H/Tera.js"

echo_box() {
    echo "╔════════════════════════════════╗"
    echo "║$(printf ' %-30s ║' "$1")"
    echo "╚════════════════════════════════╝"
}

COMMAND=$1

case "$COMMAND" in
    help)
        echo_box "$TITLE"
        echo
        echo "Commands:"
        echo "  help   ~ Shows this help menu"
        echo "  fetch  ~ Downloads $FILE_NAME, lists it, prompts before deleting"
        ;;
    fetch)
        echo_box "Fetching $FILE_NAME"
        echo "Downloading from GitHub..."
        for i in {1..3}; do
            echo -n "."
            sleep 0.5
        done
        echo
        wget -q --show-progress -O "$FILE_NAME" "$REPO_URL"
        if [ $? -eq 0 ]; then
            echo "✔ $FILE_NAME downloaded successfully!"
            ls -l "$FILE_NAME"
            read -p "Do you want to delete $FILE_NAME? (y/n): " choice
            if [[ "$choice" == [Yy] ]]; then
                rm "$FILE_NAME"
                echo "$FILE_NAME has been deleted."
            else
                echo "$FILE_NAME was not deleted."
            fi
        else
            echo "✖ Failed to download $FILE_NAME."
        fi
        ;;
    *)
        echo_box "Unknown Command"
        echo "Unknown command: $COMMAND"
        echo "Try: ter help"
        ;;
esac
EOF

# Make it executable
chmod +x "$BIN_DIR/$PKG_NAME"

# Add bin directory to PATH if needed
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo "export PATH=\$PATH:$BIN_DIR" >> ~/.bashrc
    source ~/.bashrc
fi

echo "✔ PKG '$PKG_NAME' installed! You can now run 'ter help' or 'ter fetch'"
            
