#!/bin/bash

# MQTT settings
MQTT_BROKER="localhost"
MQTT_TOPIC="#"
USER="sub_user"
PASSWD="sub_embedded"

# SQLite database file
DB_FILE="mqtt_logs.db"

# Create SQLite database table if not exists
sqlite3 $DB_FILE <<EOF
CREATE TABLE IF NOT EXISTS mqtt_logs (
    id INTEGER PRIMARY KEY,
    topic TEXT,
    message TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF

# Subscribe to MQTT messages and log them into the database
mosquitto_sub -h $MQTT_BROKER -t $MQTT_TOPIC -u $USER -P $PASSWD --verbose| while IFS= read -r line; do
    topic=$(echo "$line" | cut -d' ' -f1)
    message=$(echo "$line" | cut -d' ' -f2-)
    sqlite3 $DB_FILE "INSERT INTO mqtt_logs (topic, message) VALUES ('$topic', '$message');"
done



