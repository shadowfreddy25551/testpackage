#!/bin/bash
set -e

CONFIG_FILE="/etc/updater.conf"

if [[ $EUID -ne 0 ]]; then
  echo "Please run this as sudo."
  exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Config file not found at $CONFIG_FILE."
  echo "Please run 'config.sh' to create it first."
  exit 1
fi

echo "Running update commands from config..."

while IFS= read -r cmd || [[ -n "$cmd" ]]; do
  if [[ -z "$cmd" ]]; then
    continue
  fi
  echo "Running: $cmd"
  eval "$cmd"
done < "$CONFIG_FILE"

echo "Update complete. Rebooting in 10 seconds..."
sleep 10
reboot
