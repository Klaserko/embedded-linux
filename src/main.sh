#!/bin/bash

check_script="./check_connection.sh"
download_script="./new_download_files.sh"
annotation_script="./annotate_images.sh"
server_website="192.168.10.1:8080"
git_script="./git_push.sh"

sleep_time=6

# Activate the annotation script
$annotation_script

while true; do
    if current_wifi=$("$check_script"); then
        $download_script "../images/$current_wifi"

        # Annotate the images
        $annotation_script "../images/$current_wifi/$server_website"

        # push to git

    fi

    echo ----- One loop over, starting in $sleep_time seconds -----
    sleep $sleep_time
done