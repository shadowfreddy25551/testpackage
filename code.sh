#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Please run this as sudo."
  exit 1
fi

flatpak update -y
pacman -Syu --noconfirm
yay -Syu --noconfirm

echo "Update complete. Rebooting in 10 seconds..."
sleep 10
reboot
