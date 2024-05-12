#!/bin/bash

main_folder="/home/emli/photos"
metadata_file=$1
drone_id=$2

time_epoch=$(date +%s)
metadata_file_path="$main_folder/$metadata_file"

new_json=$(jq --arg droneID "$drone_id" --arg timeStamp "$time_epoch" '.Dawnloads += [ { "DroneID":  $droneID, "Time": $timeStamp } ]' "$metadata_file_path")

echo "$new_json" > "$metadata_file_path"

