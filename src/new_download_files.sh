#!/bin/bash

website="http://192.168.10.1:8080/"

website_dir="192.168.10.1:8080"


if [ $# -eq 0 ]; then
    exit 1
fi

download_dir="$1"

#check if directory exists, if not create it
if [ ! -d "$download_dir" ]; then
    mkdir -p "$download_dir"
fi

if ! wget -m -c --header="User: 1" -T 10 -P "$download_dir" -R "index.html*" "$website"; then
    echo "Download failed, removing incomplete file"
    cd "$download_dir/$website_dir" || exit 1
    rm $(ls -t | head -n 1)
fi