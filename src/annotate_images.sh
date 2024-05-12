#!/bin/bash

# Define the path to the folder containing the images
IMAGE_FOLDER=$1 #"/home/frederik/Documents/SDU/EMLI" /home/richard/Documents/EMLI/embedded-linux/images

# Iterate over each image file in the folder
for img_file in "$IMAGE_FOLDER"/*.jpg; do
    filename=$(basename "$img_file" .jpg)
    
    echo "Annotating $img_file"
    annotation=$(ollama run llava:7b "In short describe the image, $img_file, do not describe file path")

    # Update the JSON metadata file with the annotation
    metadata_file="${IMAGE_FOLDER}/${filename}.json"
    jq --arg annotation_text "$annotation" '.Annotation += {"Source": "Ollama:7b", "Test": $annotation_text}' "$metadata_file" > temp.json && mv temp.json "$metadata_file"

    echo "Annotation completed for $img_file"
done
