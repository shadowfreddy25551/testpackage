if [[ $EUID -ne 0 ]]; then
  echo "Please run this as sudo."
  exit 1
fi

echo "Checking for updates."
pacman -Syu
flatpak update
yay -Syu
echo "Rebooting in 10 seconds"
sleep 10
reboot
