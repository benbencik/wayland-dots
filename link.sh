#!/usr/bin/env bash

# Get the current workspace directory
WORKSPACE_DIR=$(pwd)

# Loop through all directories in the workspace
for dir in "$WORKSPACE_DIR"/*/; do
    # Get the directory name
    dir_name=$(basename "$dir")
    
    # Create a symbolic link in ~/.config
    ln -sfn "$dir" "$HOME/.config/$dir_name"
    
    echo "Created symbolic link for $dir_name in ~/.config"
done

echo "All directories in the workspace have been linked to ~/.config"