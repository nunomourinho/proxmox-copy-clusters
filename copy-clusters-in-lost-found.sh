#!/bin/bash

# Check if the required parameters are passed
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 --source <lost+found_folder> --destination <destination_folder> [--keyfile <keyfile_path>]"
    exit 1
fi

# Initialize variables
SOURCE_DIR=""
DESTINATION_DIR=""
KEYFILE=""
COPIED_COUNT=0
NOT_COPIED_COUNT=0

# Parse parameters
while [[ $# -gt 0 ]]; do
    case $1 in
        --source)
            SOURCE_DIR="$2"
            shift 2
            ;;
        --destination)
            DESTINATION_DIR="$2"
            shift 2
            ;;
        --keyfile)
            KEYFILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown parameter: $1"
            exit 1
            ;;
    esac
done

# Verify if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: The source directory $SOURCE_DIR does not exist!"
    exit 1
fi

# Create the destination directory if it does not exist
if [ ! -d "$DESTINATION_DIR" ]; then
    mkdir -p "$DESTINATION_DIR"
    echo "Destination directory created: $DESTINATION_DIR"
fi

# Create a temporary directory for decoded files
TMP_DIR=$(mktemp -d)

# Process each file in the lost+found directory
for FILE in "$SOURCE_DIR"/*; do
    if [ -f "$FILE" ]; then
        echo "Processing file: $FILE"

        # Build the proxmox-backup-debug command
        CMD="proxmox-backup-debug inspect chunk \"$FILE\" --use-filename-as-digest false"
        if [ -n "$KEYFILE" ]; then
            CMD="$CMD --keyfile \"$KEYFILE\""
        fi
        CMD="$CMD --decode \"$TMP_DIR/decoded\" > /dev/null 2>&1"

        # Execute the command
        eval $CMD
        if [ $? -ne 0 ]; then
            echo "Error decoding the file: $FILE"
            NOT_COPIED_COUNT=$((NOT_COPIED_COUNT + 1))
            continue
        fi

        # Calculate the SHA-256 checksum
        REAL_NAME=$(sha256sum "$TMP_DIR/decoded" | awk '{print $1}')
        echo "Real cluster name for $FILE: $REAL_NAME"

        # Determine the subdirectory based on the first four characters of the real name
        SUB_DIR="$DESTINATION_DIR/${REAL_NAME:0:4}"

        # Create the subdirectory if it does not exist
        if [ ! -d "$SUB_DIR" ]; then
            mkdir -p "$SUB_DIR"
            echo "Subdirectory created: $SUB_DIR"
        fi

        # Copy the file to the subdirectory with the discovered name
        cp "$FILE" "$SUB_DIR/$REAL_NAME"
        if [ $? -eq 0 ]; then
            echo "File copied to: $SUB_DIR/$REAL_NAME"
            COPIED_COUNT=$((COPIED_COUNT + 1))
        else
            echo "Failed to copy file: $FILE"
            NOT_COPIED_COUNT=$((NOT_COPIED_COUNT + 1))
        fi
    fi
done

# Clean up the temporary directory
rm -rf "$TMP_DIR"

# Display the final statistics
echo "Processing completed."
echo "Files copied successfully: $COPIED_COUNT"
echo "Files not copied: $NOT_COPIED_COUNT"
