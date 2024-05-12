#!/bin/bash

# MQTT Broker Details
MQTT_BROKER="localhost"
TOPIC_TO_PICO="sub_user/to/pico"
TOPIC_FROM_PICO="pico_user/from/pico"
USER="sub_user"
PASSWD="sub_embedded"

move_servo() {
    angle=$1
    mosquitto_pub -h $MQTT_BROKER -t $TOPIC_TO_PICO -u $USER -P $PASSWD -m "{\"wiper_angle\": $angle}"
}

mosquitto_sub -h $MQTT_BROKER -t $TOPIC_FROM_PICO -u $USER -P $PASSWD | while read -r message; do
    rain_detect=$(echo "$message" | jq -r '.rain_detect')
    if [ "$rain_detect" = "1" ]; then
        
        # Move servo from 0 to 180 and back to 0
        
        move_servo 180
        sleep 5
        move_servo 0
        sleep 5
    fi
done
