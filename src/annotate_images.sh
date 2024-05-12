#!/bin/bash

# Define the path to the folder containing the images
IMAGE_FOLDER="$1"

# Find all JPEG files recursively in the IMAGE_FOLDER directory
find "$IMAGE_FOLDER" -type f -name "*.jpg" | while read -r img_file; do
    # Extract filename without extension
    filename=$(basename "$img_file" .jpg)

    # Run ollama command to annotate the image
    annotation=$(ollama run llava:7b "In short describe image $img_file, do not describe the file path")

    # Update the JSON metadata file with the annotation
    metadata_file="${IMAGE_FOLDER}/${filename}.json"
    jq --arg annotation_text "$annotation" '.Annotation += {"Source": "Ollama:7b", "Test": $annotation_text}' "$metadata_file" > temp.json && mv temp.json "$metadata_file"

    echo "Annotation completed for $img_file"
done
