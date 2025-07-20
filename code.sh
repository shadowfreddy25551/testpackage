#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Please run this as sudo."
  exit 1
fi

PKG="updaterv2"

pacman -Sy --noconfirm >/dev/null 2>&1
yay -Sy --noconfirm >/dev/null 2>&1

INST_VER=$(pacman -Q $PKG 2>/dev/null | awk '{print $2}')
if [[ -z "$INST_VER" ]]; then
  echo "$PKG is not installed."
  exit 1
fi

REPO_VER=$(pacman -Si $PKG 2>/dev/null | awk '/Version/ {print $3}')
AUR_VER=$(yay -Si $PKG 2>/dev/null | awk '/Version/ {print $3}')

ver_lt() {
  [[ "$1" == "$2" ]] && return 1
  [[ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$2" ]]
}

NEWER_AVAILABLE=0

if ver_lt "$INST_VER" "$REPO_VER"; then
  echo "Newer version $REPO_VER available in repo."
  NEWER_AVAILABLE=1
fi

if ver_lt "$INST_VER" "$AUR_VER"; then
  echo "Newer version $AUR_VER available in AUR."
  NEWER_AVAILABLE=1
fi

if [[ $NEWER_AVAILABLE -eq 1 ]]; then
  echo "Update halted. Please update $PKG manually first."
  exit 1
fi

pacman -Syu --noconfirm
flatpak update -y
yay -Syu --noconfirm

echo "Rebooting in 10 seconds..."
sleep 10
reboot
