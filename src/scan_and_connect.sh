#!/bin/bash

wifi_list_file="wifi_list.txt"
wifi_interface="wlp0s20f3"  # Change this to your Wi-Fi interface name

connect_to_wifi_script="./connect_to_camera.sh"

# Function to scan for available Wi-Fi networks
scan_wifi() {
    echo "Scanning for Wi-Fi networks..."
    available_ssids=$(sudo iw dev "$wifi_interface" scan | grep 'SSID' | sort | uniq -c | cut -d ':' -f 2-)
    echo "Available wifis"
    echo "$available_ssids"
}

# Check if wifi_list.txt exists
if [ ! -f "$wifi_list_file" ]; then
    echo "Error: wifi_list.txt not found"
    exit 1
fi

# Scan for available Wi-Fi networks
scan_wifi

connection_successful=false

# Loop through each SSID in wifi_list.txt
while IFS= read -r line; do
    ssid=$(echo "$line" | cut -d ' ' -f 1)
    password=$(echo "$line" | cut -d ' ' -f 2)

    # Check if the SSID is in the list of available networks
    # echo "$available_ssids" | grep -q "$ssid"
    if echo "$available_ssids" | grep -q "$ssid"; then
        if $connect_to_wifi_script "$ssid" "$password"; then
            # Set flag indicating successful connection
            connection_successful=true
            break
        fi
    fi
done < "$wifi_list_file"

if [ "$connection_successful" = false ]; then
    echo "No matching Wi-Fi network found"
else 
    echo "Connected to Wi-Fi network successfully"
fi
