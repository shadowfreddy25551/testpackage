#!/bin/bash

CONFIG_FILE="/etc/updater.conf"

if [[ $EUID -ne 0 ]]; then
  echo "Please run this as sudo."
  exit 1
fi

echo "please run updater-config to configure the updater."

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Config file not found at $CONFIG_FILE."
  echo "Please run 'config.sh' to create it first."
  exit 1
fi

echo "Running update commands from $CONFIG_FILE..."

while IFS= read -r cmd; do
  [[ -z "$cmd" ]] && continue
  echo "Running: $cmd"
  eval "$cmd"
  if [[ $? -ne 0 ]]; then
    echo "Command failed: $cmd"
    exit 1
  fi
done < "$CONFIG_FILE"

echo "Update complete. Rebooting in 10 seconds..."
sleep 10
reboot
