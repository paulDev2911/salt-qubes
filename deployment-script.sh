#!/bin/bash

APP_VM="personal-dev"
REPO_DIR="salt/salt-qubes"
SALT_DIR="$REPO_DIR/salt"
FORMULAS_DIR="$REPO_DIR/formulas"
PILLAR_DIR="$REPO_DIR/pillar"

DOM0_SALT_DIR="/srv/user_salt"
DOM0_FORMULAS_DIR="/srv/user_formulas"
DOM0_PILLAR_DIR="/srv/user_pillar"

# Function to copy files and directories recursively
copy_files() {
  local source_dir="$1"
  local dest_dir="$2"

  # Create the target directory if it doesn't exist
  sudo mkdir -p "$dest_dir"

  # Loop through each item in the source directory
  for item in $(qvm-run --pass-io $APP_VM "ls $source_dir"); do
    local source_item="$source_dir/$item"
    local dest_item="$dest_dir/$item"

    if [[ $(qvm-run --pass-io $APP_VM "test -d $source_item && echo 'dir' || echo 'file'") == "dir" ]]; then
      # If it's a directory, recurse
      echo "Copying directory $source_item to $dest_item..."
      copy_files "$source_item" "$dest_item"
    else
      # If it's a file, copy it
      echo "Copying file $source_item to $dest_item..."
      qvm-run --pass-io $APP_VM "cat $source_item" | sudo tee "$dest_item" > /dev/null
    fi
  done
}

# Step 1: Delete old files in dom0 directories
echo "Deleting old files in dom0 directories..."
sudo rm -rf $DOM0_SALT_DIR/*
sudo rm -rf $DOM0_FORMULAS_DIR/*
sudo rm -rf $DOM0_PILLAR_DIR/*

# Step 2: Copy new files from the test VM repo to dom0
echo "Copying files from the test VM repo to dom0..."

# Start by copying everything from the directories
copy_files "$SALT_DIR" "$DOM0_SALT_DIR"
copy_files "$FORMULAS_DIR" "$DOM0_FORMULAS_DIR"
copy_files "$PILLAR_DIR" "$DOM0_PILLAR_DIR"

# Copy the top.sls files from salt and pillar directories to dom0
echo "Copying top.sls files from salt and pillar to dom0..."

# Copy /salt/top.sls to /srv/user_salt/top.sls in dom0
qvm-run --pass-io $APP_VM "cat $SALT_DIR/top.sls" | sudo tee /srv/user_salt/top.sls > /dev/null

# Copy /pillar/top.sls to /srv/user_pillar/top.sls in dom0
qvm-run --pass-io $APP_VM "cat $PILLAR_DIR/top.sls" | sudo tee /srv/user_pillar/top.sls > /dev/null

echo "Transfer completed. Please check dom0 for the files."

exit 0
