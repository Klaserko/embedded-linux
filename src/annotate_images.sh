#!/bin/bash

# Define the path to the folder containing the images
IMAGE_FOLDER="$1"

# Find all JPEG files recursively in the IMAGE_FOLDER directory
find "$IMAGE_FOLDER" -type f -name "*.jpg" | while read -r img_file; do
    echo "Processing image: $img_file"
    # Extract filename without extension
    filename=$(basename "$img_file" .jpg)
    dir_name=$(dirname "$img_file")

    # JSON metadata file
    metadata_file="${dir_name}/${filename}.json"

    # Check if metadata file exists
    if [ -f "$metadata_file" ]; then
        # Check if "Annotation" field exists in the metadata
        if ! jq -e '.Annotation' "$metadata_file" >/dev/null; then
            # Run ollama command to annotate the image
            echo "Starting annotation for $img_file"

            param="$img_file"

            annotation=$(ollama run llava:7b "In short describe this image: ${dir_name}/${filename}.jpeg, Do not describe the path, only the image.")

            # Update the JSON metadata file with the annotation
            jq --arg annotation_text "$annotation" '.Annotation += {"Source": "Ollama:7b", "Test": $annotation_text}' "$metadata_file" > temp.json && mv temp.json "$metadata_file"

            echo "Annotation completed for $img_file"
        else
            echo "Annotation already exists for $img_file"
        fi
    else
        echo "Metadata file not found for $metadata_file"
    fi
done

