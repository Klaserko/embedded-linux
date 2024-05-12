#!/bin/bash

check_script="./check_connection.sh"
download_script="./new_download_files.sh"
annotation_script="./annotate_images.sh"
server_website="192.168.10.1:8080"
git_script="./git_push.sh"
logging_script="./log_wifi_link.sh"

sleep_time=6

# Activate the logging script
$logging_script $check_script &

downloaded=false

while true; do
    if current_wifi=$("$check_script"); then
        $download_script "../images/$current_wifi"
        downloaded=true
    fi

    if [ "$downloaded" = true ]; then
        # Annotate the images
        $annotation_script "../images/$current_wifi/$server_website"

        echo "Annotation finished, pushing to git"
        $git_script

        exit 0
    fi

    
done