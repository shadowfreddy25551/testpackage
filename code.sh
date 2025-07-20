#!/bin/bash

CONFIG_FILE="/etc/updater.conf"
FIRST_RUN_FLAG="/etc/updater.first_run"

if [[ $EUID -ne 0 ]]; then
  echo "Please run this as sudo."
  exit 1
fi

# Check if it's the first run
if [[ ! -f "$CONFIG_FILE" || -f "$FIRST_RUN_FLAG" ]]; then
  echo "First time setup detected."
  echo "Please run 'config.sh' to set up your update configuration."
  echo "You can run: sudo ./config.sh"
  touch "$FIRST_RUN_FLAG"
  exit 1
fi

echo "Running update commands from config..."

while IFS= read -r cmd; do
  [[ -z "$cmd" ]] && continue
  echo "Running: $cmd"
  eval "$cmd"
  if [[ $? -ne 0 ]]; then
    echo "Command failed: $cmd"
    exit 1
  fi
done < "$CONFIG_FILE"

# Once it has run once, we remove the flag
rm -f "$FIRST_RUN_FLAG"

echo "Update complete. Rebooting in 10 seconds..."
sleep 10
reboot
