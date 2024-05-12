#!/bin/bash

# Check if the parameter is provided
if [ $# -eq 0 ]; then
    echo "Error: Please provide the trigger name as an argument"
    exit 1
fi


if [ "$1" = "Time" ] || [ "$1" = "Manual" ]; then

    # Assign the parameter to a variable
    trigger="$1"


    # Get the current local date and time in the specified format
    current_date=$(date +'%Y-%m-%d')
    current_time=$(date +'%H%M%S')
    current_ms=$(date +'%N' | cut -b1-3)

    # Create the directory if it doesn't exist
    photo_directory="/home/emli/photos/$current_date"
    mkdir -p "$photo_directory"

    # Generate the filename using the current date and time
    photo_filename="${current_time}_${current_ms}.jpg"
    photo_file_path="$photo_directory/$photo_filename"
    metadata_filename="${current_time}_${current_ms}.json"
    metadata_file_path="$photo_directory/$metadata_filename"

    # Take the picture
    rpicam-still -t 0.01 -o "$photo_file_path"

    # Generate Metadata
    /home/emli/camera_scripts/generate_metadata.sh "$photo_directory" "$photo_filename" "$metadata_filename" "$trigger"
fi
