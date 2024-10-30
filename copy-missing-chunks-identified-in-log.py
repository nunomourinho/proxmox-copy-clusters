import os
import shutil
import argparse
import re

# Regular expression to capture chunk hashes from log entries
CHUNK_REGEX = re.compile(r"chunk (\w{64})")

def read_missing_chunks(log_file):
    """Reads the log file and extracts paths of missing or corrupt chunks."""
    missing_chunks = []
    with open(log_file, 'r') as f:
        for line in f:
            match = CHUNK_REGEX.search(line)
            if match:
                # Capture the full chunk hash
                chunk_hash = match.group(1)
                missing_chunks.append(chunk_hash)
    return missing_chunks

def copy_chunks(missing_chunks, chunks_folder, output_folder):
    """Copies each missing chunk to the specified output directory, maintaining folder structure."""
    for chunk_hash in missing_chunks:
        # Get the subfolder from the first 4 characters of the chunk hash
        subfolder = chunk_hash[:4]
        filename = chunk_hash
        source_path = os.path.join(chunks_folder, subfolder, filename)
        
        if os.path.exists(source_path):
            # Create the directory structure in the output folder
            destination_path = os.path.join(output_folder, subfolder)
            os.makedirs(destination_path, exist_ok=True)
            
            # Copy the chunk file to the destination
            shutil.copy2(source_path, os.path.join(destination_path, filename))
            print(f"Copied {filename} to {destination_path}")
        else:
            print(f"Chunk {filename} not found at {source_path}")

def main():
    parser = argparse.ArgumentParser(description="Copy missing or corrupt chunks to the output directory.")
    parser.add_argument("--log", required=True, help="Path to the log file containing missing or corrupt chunks")
    parser.add_argument("--chunks", required=True, help="Folder where the chunks are stored")
    parser.add_argument("--output", required=True, help="Destination folder to copy the missing chunks")
    args = parser.parse_args()

    # Read missing chunks from the log file
    missing_chunks = read_missing_chunks(args.log)

    # Copy missing chunks to the output directory
    copy_chunks(missing_chunks, args.chunks, args.output)

if __name__ == "__main__":
    main()
