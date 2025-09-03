#!/bin/bash
# Tera dox v0.01 - CLI for Termux

TITLE="Tera dox v0.01"
REPO_URL="https://raw.githubusercontent.com/lucent-hub/Lucent/main/Extra/UI/A/H/H/Tera.js"
FILE_NAME="Tera.js"

# Function to print a box banner
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
        echo "  update ~ Downloads or updates $FILE_NAME from GitHub"
        echo "More commands coming soon ..."
        ;;
    update)
        echo_box "Updating $FILE_NAME"
        echo "Downloading latest version from GitHub..."
        wget -O "$FILE_NAME" "$REPO_URL"
        if [ $? -eq 0 ]; then
            echo "✔ $FILE_NAME downloaded/updated successfully!"
        else
            echo "✖ Failed to download $FILE_NAME. Check your internet or URL."
        fi
        ;;
    *)
        echo_box "Unknown Command"
        echo "Unknown command: $COMMAND"
        echo "Try: ./tera.sh help"
        ;;
esac
