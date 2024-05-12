#!/bin/bash

photos_folder=$1
photo_file_name=$2
metadata_file_name=$3
trigger=$4

photo_file_path="$photos_folder/$photo_file_name"
metadata_file_path="$photos_folder/$metadata_file_name"

# Generate Metadata
metadata=$(/usr/local/bin/exiftool -args -ExposureTime -SubjectDistance -ISO -j "$photo_file_path")
create_date=$(/usr/local/bin/exiftool -CreateDate -s3 -d "%Y-%m-%d %H:%M:%S" "$photo_file_path")
create_date_epoch=$(/usr/local/bin/exiftool -CreateDate -s5 -d "%s" "$photo_file_path")
metadata="${metadata:1:${#metadata}-2}"  # Remove first and last character

echo "$metadata" | jq --arg photoFilename "$photo_file_name" --arg triggerType "$trigger" --arg createDate "$create_date" --arg createDateEpoch "$create_date_epoch" ' . += { "FileName": $photoFilename, "Trigger": $triggerType, "CreateDate": $createDate, "CreateSecondsEpoch": $createDateEpoch}' | jq 'del(.SourceFile)' > "$metadata_file_path"

