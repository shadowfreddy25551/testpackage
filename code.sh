#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Please run this as sudo."
  exit 1
fi

PKG="updaterv2"

ver_lt() {
  [[ "$1" == "$2" ]] && return 1
  [[ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$2" ]]
}

check_newer() {
  pacman -Sy --noconfirm >/dev/null 2>&1

  INST_VER=$(pacman -Q $PKG 2>/dev/null | awk '{print $2}')
  if [[ -z "$INST_VER" ]]; then
    echo "$PKG is not installed."
    exit 1
  fi

  REPO_VER=$(pacman -Si $PKG 2>/dev/null | awk '/Version/ {print $3}')
  AUR_VER=$(curl -s "https://aur.archlinux.org/rpc/?v=5&type=info&arg=$PKG" | jq -r '.results.Version')

  if ver_lt "$INST_VER" "$REPO_VER"; then
    echo "Newer version $REPO_VER available in repo."
    return 1
  fi

  if ver_lt "$INST_VER" "$AUR_VER"; then
    echo "Newer version $AUR_VER available in AUR."
    return 1
  fi

  return 0
}

echo "Checking for newer version before update..."
if ! check_newer; then
  echo "Update halted. Please update $PKG manually first."
  exit 1
fi

flatpak update -y
pacman -Syu --noconfirm
yay -Syu --noconfirm

echo "Checking for newer version after update..."
if ! check_newer; then
  echo "Newer version detected after update. Please update $PKG manually."
  exit 1
fi

echo "Rebooting in 10 seconds..."
sleep 10
reboot
