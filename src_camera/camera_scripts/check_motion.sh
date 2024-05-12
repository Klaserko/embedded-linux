#!/bin/bash

temp_folder="/home/emli/photos_temp"
dst_photos_folder="/home/emli/photos"

# Get the current local date and time in the specified format
current_date=$(date +'%Y-%m-%d')
current_time=$(date +'%H%M%S')
current_ms=$(date +'%N' | cut -b1-3)

# Generate the filename using the current date and time
photo_filename="${current_time}_${current_ms}.jpg"
photo_file_path="$temp_folder/$photo_filename"

# Take the picture
rpicam-still -t 0.01 -o "$photo_file_path"

# Check the number of files in the temp folder
file_count=$(ls "$temp_folder" | wc -l)

# If there are less than two files, exit the script
if [ "$file_count" -lt 2 ]; then
    echo "Less than two files in the temp folder. Exiting."
    exit 1
fi


# If there are more than two files, delete all except the newest two
if [ "$file_count" -gt 2 ]; then
    # List files in the temp folder, sorted by modification time (newest first)
    files_to_delete=$(ls -t "$temp_folder" | tail -n +3)

    # Delete the older files
    for file in $files_to_delete; do
        rm "$temp_folder/$file"
        echo "Deleted: $temp_folder/$file"
    done
fi

# Run python script on the last two files left in the folder
last_two_files=($(ls -t "$temp_folder" | head -n 2))

motion=$(python3 motion_detect.py "$temp_folder/${last_two_files[0]}" "$temp_folder/${last_two_files[1]}")

if [ "$motion" = "Motion detected" ]; then
    destination_folder="$dst_photos_folder/$current_date"

    mkdir "$destination_folder"
    cp "$temp_folder/$photo_filename" "$destination_folder/$photo_filename"

    # Generate Metadata
    /home/emli/camera_scripts/generate_metadata.sh "$destination_folder" "$photo_filename" "${current_time}_${current_ms}.json" "Motion"

fi
