#!/bin/bash
# Real PKG installer with fake install output

if [ "$1" != "install" ] || [ -z "$2" ]; then
    echo "Usage: pkg install <URL>"
    exit 1
fi

URL="$2"
FILENAME=$(basename "$URL")

# Fake installer messages
echo "Updating package database..."
sleep 1
echo "Fetching package metadata..."
sleep 1
echo "Resolving dependencies..."
sleep 1
echo "Downloading $URL..."

# Actual file download
wget -q --show-progress "$URL" -O "$FILENAME"

if [ $? -eq 0 ]; then
    echo "Installing $FILENAME..."
    sleep 1
    echo "Package installed successfully: $FILENAME 🎉"
else
    echo "Error: Download failed."
fi
