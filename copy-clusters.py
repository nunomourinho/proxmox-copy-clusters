import os
import struct
import shutil
import argparse
from tqdm import tqdm
import time

def read_fidx(fidx_file):
    """Reads the .fidx file and returns a set of unique chunk digests."""
    chunk_digests = set()  # Use a set to avoid duplicates
    with open(fidx_file, 'rb') as f:
        f.seek(4096)  # Skip the 4096-byte header
        
        # Read each 32-byte digest until the end of the file
        while chunk := f.read(32):
            chunk_digests.add(chunk.hex())  # Add to the set
    
    return chunk_digests

def copy_chunks(digests, chunks_folder, output_folder):
    """Copies unique chunks based on digests to the output folder, showing progress."""
    total_chunks = len(digests)
    start_time = time.time()

    with tqdm(total=total_chunks, desc="Copy Progress", unit="chunk") as pbar:
        for digest in digests:
            # Get subfolder with the first 4 characters of the digest
            subfolder = digest[:4]
            filename = digest
            source_path = os.path.join(chunks_folder, subfolder, filename)
            
            if os.path.exists(source_path):
                # Create the folder structure in the destination
                dest_path = os.path.join(output_folder, subfolder)
                os.makedirs(dest_path, exist_ok=True)
                
                # Copy the file to the destination
                shutil.copy2(source_path, os.path.join(dest_path, filename))
            
            # Update the progress bar
            pbar.update(1)
            elapsed_time = time.time() - start_time
            pbar.set_postfix_str(f"Elapsed Time: {elapsed_time:.2f} s")

def main():
    parser = argparse.ArgumentParser(description="Copies chunks from a .fidx file to a destination folder.")
    parser.add_argument("--index", required=True, help="Path to the .fidx file")
    parser.add_argument("--chunks", required=True, help="Folder where the chunks are stored")
    parser.add_argument("--output", required=True, help="Destination folder to copy chunks")
    args = parser.parse_args()
    
    # Read unique chunk digests from the .fidx file
    digests = read_fidx(args.index)
    
    # Copy unique chunks to the output folder with progress
    copy_chunks(digests, args.chunks, args.output)

if __name__ == "__main__":
    main()
