#!/bin/bash

CONFIG_FILE="/etc/updater.conf"

echo "Configure which update commands to run."
echo "Enter commands one per line. Leave empty line to finish."
echo "Default (if none entered):"
echo "flatpak update -y"
echo "pacman -Syu --noconfirm"
echo "yay -Syu --noconfirm"
echo

commands=()

while true; do
  read -rp "Command to run (empty to finish): " cmd
  if [[ -z "$cmd" ]]; then
    break
  fi
  commands+=("$cmd")
done

if [ ${#commands[@]} -eq 0 ]; then
  commands=(
    "flatpak update -y"
    "pacman -Syu --noconfirm"
    "yay -Syu --noconfirm"
  )
fi

# Save commands to config file
sudo bash -c "printf '%s\n' \"${commands[@]}\" > $CONFIG_FILE"

echo "Config saved to $CONFIG_FILE:"
cat "$CONFIG_FILE"

