#!/bin/bash

# A recursive function to list directories and files with indentation.
# @param $1 The directory to list.
# @param $2 The current indentation string.
treelist() {
  local dir="$1"
  local indent="$2"
  
  # Set up special characters for the tree drawing
  local last_entry=$(ls -A "$dir" | tail -n 1)

  # Loop through all files and directories in the current directory.
  # Use dotglob and nullglob to include hidden files and handle empty directories.
  shopt -s dotglob nullglob
  for entry in "$dir"/*; do
    local entry_name=$(basename "$entry")

    # Determine the prefix for the current line.
    local prefix="|_"
    local next_indent="$indent|    "
    if [[ "$entry_name" == "$last_entry" ]]; then
      prefix="|_"
      next_indent="$indent     "
    fi

    # Print the entry name with the correct indentation.
    printf "%s%s%s\n" "$indent" "$prefix" "$entry_name"

    # Recursively call the function if the entry is a directory.
    if [[ -d "$entry" ]]; then
      treelist "$entry" "$next_indent"
    fi
  done
}

# Get the directory to list from the command-line argument.
# If no argument is given, use the current directory.
target_dir="${1:-.}"

# Check if the target directory exists.
if [[ ! -d "$target_dir" ]]; then
  echo "Error: Directory '$target_dir' not found."
  exit 1
fi

# Print the root directory.
echo "$target_dir"

# Start the recursive listing from the target directory.
treelist "$target_dir"
