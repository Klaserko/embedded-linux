#!/bin/bash

# MQTT Broker Details
MQTT_BROKER="localhost"
TOPIC="esp_user/from/esp"
USER="sub_user"
PASSWD="sub_embedded"

mosquitto_sub -h $MQTT_BROKER -t $TOPIC -u $USER -P $PASSWD| while read -r message; do
    button_press=$(echo "$message" | jq -r '.button_press')
    if [ "$button_press" = "1" ]; then
       /home/emli/camera_scripts/take_photo.sh Manual
    fi
done
