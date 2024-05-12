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

download_ready=false

while true; do
    if current_wifi=$("$check_script"); then
        $download_script "../images/$current_wifi"
        download_ready=true

        # push to git
        $git_script
    fi

    if [ "$download_ready" = true && "$check_script" = false]; then
        # Annotate the images
        $annotation_script "../images/$current_wifi/$server_website"
        download_ready=false
    fi

    echo ----- One loop over, starting in $sleep_time seconds -----
    sleep $sleep_time
done