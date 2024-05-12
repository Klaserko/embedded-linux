#!/bin/bash

check_script="./check_connection.sh"
download_script="./new_download_files.sh"
annotation_script="./annotate_images.sh"
logging_script="./log_wifi_link.sh"
git_script="./git_push.sh"
scan_and_connect_script="./scan_and_connect.sh"


website_dir="192.168.10.1:8080"
camera_wifi_ip="192.168.10.1"

# Activate the logging script
$logging_script $check_script &


while true; do
    if current_wifi=$("$check_script"); then
        echo "#################### Connected to $current_wifi, Sync the time ####################"
        ssh emli@$camera_wifi_ip sudo date -s @$(date -u +"%s")

        echo "#################### Start download ####################"
        $download_script "../images/$current_wifi"

        echo "#################### Download finished, starting annotation ####################"
        $annotation_script "../images/$current_wifi/$website_dir/"

        echo "#################### Annotation finished, pushing to git ####################"
        $git_script

        exit 0

    else 
        # Try to connect to wifi
        echo "#################### Not connected to any wifi, trying to connect ####################"
        $scan_and_connect_script
    fi

    
done