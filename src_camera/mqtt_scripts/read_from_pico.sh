#!/bin/bash

# MQTT Broker Details
MQTT_BROKER="localhost"
TOPIC_TO_PICO="sub_user/to/pico"
TOPIC_FROM_PICO="pico_user/from/pico"
serial_port="/dev/ttyACM0"
USER="pico_user"
PASSWD="pico_embedded"

last_payload="1"
publish_to_mqtt() {
    local payload=$1
    rain_detect=$(echo "$payload" | jq -r '.rain_detect')
    if [ "$rain_detect" != "$last_payload" ]; then
        echo "Publish"
        mosquitto_pub -h $MQTT_BROKER -t $TOPIC_FROM_PICO -u $USER -P $PASSWD -m "$payload"
        last_payload=$rain_detect
    fi
}


forward_to_pico() {
    mosquitto_sub -h $MQTT_BROKER -t $TOPIC_TO_PICO -u $USER -P $PASSWD| while read message
    do
        echo "$message" > $serial_port
    done &
}

main() {
    # Set baud rate and other options if needed
    stty -F $serial_port 9600 raw -echo
    while true; do

        # Read a line of data from serial port
        read -r line < "$serial_port"

        # Read JSON data from Pico 
        pico_data=$line
        
        # Publish data to MQTT
        publish_to_mqtt "$pico_data"

        # Subscribe to MQTT and handle incoming messages
        forward_to_pico
    done
}

main
