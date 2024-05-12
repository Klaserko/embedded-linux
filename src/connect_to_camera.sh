#!/bin/bash

ssid="$1"
password="$2"
connection_timeout=10

echo "Connecting to $ssid with password $password..."

if nmcli dev wifi connect "$ssid" password "$password"; then
    exit 0
else
    exit 1  
fi