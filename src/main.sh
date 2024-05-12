#!/bin/bash

check_script="./check_connection.sh"
download_script="./new_download_files.sh"
annotation_script="./annotate_images.sh"
website_dir="192.168.10.1:8080"
git_script="./git_push.sh"
logging_script="./log_wifi_link.sh"

sleep_time=6

# Activate the logging script
# $logging_script $check_script &


while true; do
    if current_wifi=$("$check_script"); then
        echo "Connected to $current_wifi, starting download"
        $download_script "../images/$current_wifi"

        echo "Download finished, starting annotation"
        $annotation_script "../images/$current_wifi/$website_dir"

        echo "Annotation finished, pushing to git"
        $git_script

        exit 0
    fi

    
done