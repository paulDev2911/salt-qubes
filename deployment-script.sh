#!/bin/bash

APP_VM="test-appvm"
REPO_DIR="salt/salt-qubes"
SALT_DIR="$REPO_DIR/salt"
FORMULAS_DIR="$REPO_DIR/formulas"
PILLAR_DIR="$REPO_DIR/pillar"

DOM0_SALT_DIR="/srv/user_salt"
DOM0_FORMULAS_DIR="/srv/user_formulas"
DOM0_PILLAR_DIR="/srv/user_pillar"

echo "Deleting old files in dom0 directories..."
sudo rm -rf $DOM0_SALT_DIR/*
sudo rm -rf $DOM0_FORMULAS_DIR/*
sudo rm -rf $DOM0_PILLAR_DIR/*

echo "Copying new files from the test VM repo to dom0..."

# Use qvm-copy-from to transfer files from the test VM to dom0
qvm-copy-from --target=dom0 $APP_VM:$SALT_DIR $DOM0_SALT_DIR
qvm-copy-from --target=dom0 $APP_VM:$FORMULAS_DIR $DOM0_FORMULAS_DIR
qvm-copy-from --target=dom0 $APP_VM:$PILLAR_DIR $DOM0_PILLAR_DIR

echo "Transfer initiated. Please check dom0 for the files."

exit 0
