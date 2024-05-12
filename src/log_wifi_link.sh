#!/bin/bash

# SQLite database file
DB_FILE="wifi_logs.db"
WIFI_NAME="wlp0s20f3"

if [ $# -eq 0 ]; then
    exit 1
fi

check_script="$1"

# Create SQLite table if it doesn't exist
sqlite3 $DB_FILE <<EOF
CREATE TABLE IF NOT EXISTS wifi_logs (
    id INTEGER PRIMARY KEY,
    epoch_seconds INTEGER,
    link_quality INTEGER,
    signal_level INTEGER
);
EOF

while true; do
    if $("$check_script"); then
        # Get current epoch time in seconds
        epoch_seconds=$(date +%s)
        
        # Get WiFi link quality and signal level from /proc/net/wireless
        wifi_data=$(cat /proc/net/wireless | grep $WIFI_NAME) 
        link_quality=$(echo $wifi_data | awk '{print $3}')
        signal_level=$(echo $wifi_data | awk '{print $4}')
        
        sqlite3 $DB_FILE "INSERT INTO wifi_logs (epoch_seconds, link_quality, signal_level) VALUES ('$epoch_seconds', '$link_quality', '$signal_level');"

    fi
    sleep 2
done
