#!/bin/bash

# apt update && apt upgrade -y && apt install curl
# RUN AS NORMAL USER
if [ "$EUID" -eq 0 ]; then
  echo "❌ Do not run this script as root."
  exit 1
fi

sudo apt install -y git capstone gdb python3 python3-pip tmux python3-venv

# Define installation path
INSTALL_DIR_PWNDBG="/pwndbg"
SOURCE_CMD_PWNDBG="source $INSTALL_DIR_PWNDBG/gdbinit.py"

INSTALL_DIR_GEF="/gef"
SOURCE_CMD_GEF="source $INSTALL_DIR_GEF/gdbinit.py"

GDBINIT_FILE="$HOME/.gdbinit"

# Make gdbinit if it doesn't exist
if [ ! -e "$HOME/.gdbinit" ]; then
    touch "$HOME/.gdbinit"
fi

# Ensure script is run from the home directory
if [ "$PWD" != "$HOME" ]; then
    echo "[-] Please run this script from your home directory: $HOME"
    exit 1
fi

# Clone Pwndbg if not already cloned
if [ ! -d "$INSTALL_DIR_PWNDBG" ]; then
    git clone https://github.com/pwndbg/pwndbg "$INSTALL_DIR_PWNDBG"
else
    echo "[*] Pwndbg is already cloned."
fi

# Clone gef from bata24
if [ ! -d "$INSTALL_DIR" ]; then
    git clone https://github.com/bata24/gef "$INSTALL_DIR_GEF"
else
    echo "[*] Gef is already cloned."
fi



# Go into pwndbg repo
sudo chmod +x setup.sh
cd "$INSTALL_DIR_PWNDBG" && sudo ./setup.sh

# Go into gef repo
sudo chmod +x install.sh
cd "$INSTALL_DIR_GEF" && sudo ./install.sh



# run "use-gef" or "use-pwndbg" within gdb to switch to that one 

# default to pwndbg
echo "source $INSTALL_DIR_PWNDBG/gdbinit.py" >> "$GDBINIT_FILE"
echo "" >> "$GDBINIT_FILE"

# Add command to switch to Pwndbg
echo "define use-pwndbg" >> "$GDBINIT_FILE"
echo "  source $INSTALL_DIR_PWNDBG/gdbinit.py" >> "$GDBINIT_FILE"
echo "end" >> "$GDBINIT_FILE"
echo "" >> "$GDBINIT_FILE"

# Add command to switch to GEF
echo "define use-gef" >> "$GDBINIT_FILE"
echo "  source $INSTALL_DIR_GEF/gef.py" >> "$GDBINIT_FILE"
echo "end" >> "$GDBINIT_FILE"
