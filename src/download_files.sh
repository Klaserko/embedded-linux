#!/bin/bash

website="http://192.168.10.1:8080/"

metadata="drone_id=1"

if [ $# -eq 0 ]; then
    exit 1
fi

download_dir="$1"

# Download index.html using wget
if ! wget -q "$website" -O index.html; then
    echo "server not working"
    exit 1
fi

# Extract filenames from index.html
file_list=$(grep -o '<a href=".*">' index.html | sed 's/<a href="//;s/">//')

echo $file_list

# Create the download directory if it doesn't exist
mkdir -p "$download_dir"

# Loop through each file in the list
for file in $file_list; do
    # Check if the file already exists in the download directory
    if [ -e "$download_dir/$file" ]; then
        echo "'$file' already exists"
        continue
    fi

    echo "Downloading $file"
if ! wget -q -P "$download_dir" "$website$file?$metadata" -O "$download_dir/$file"; then
    echo "Download failed, removing uncomplete file"
    rm "$download_dir/$file"
fi
done

# Clean up - remove index.html
rm index.html

