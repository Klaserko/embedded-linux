#!/bin/bash

ssid_file="wifi_list.txt"  # File containing list of SSIDs to check

connected_ssid=$(iwgetid -r)

if [ -z "$connected_ssid" ]; then
    exit 1
fi
wifi_connected=false
# Check connection for each SSID in the file
while IFS= read -r line; do
    ssid=$(echo "$line" | cut -d ' ' -f 1)

    if [ "$connected_ssid" == "$ssid" ]; then
        wifi_connected=true
    fi
done < "$ssid_file"

if [ "$wifi_connected" = true ]; then
    echo "$connected_ssid"
    exit 0
else
    exit 1
fi
