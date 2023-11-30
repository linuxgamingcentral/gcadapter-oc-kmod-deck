#!/bin/bash

# If a password was set by the program, this will run when the program closes
temp_pass_cleanup() {
  echo $PASS | sudo -S -k passwd -d deck
}

# Removes unhelpful GTK warnings
zen_nospam() {
  zenity 2> >(grep -v 'Gtk' >&2) "$@"
}

# Check if GitHub is reachable
if ! curl -Is https://github.com | head -1 | grep 200 > /dev/null
then
    echo "GitHub appears to be unreachable, you may not be connected to the Internet."
    exit 1
fi

# If the script is not root yet, get the password and re-run as root
if (( $EUID != 0 )); then
    PASS_STATUS=$(passwd -S deck 2> /dev/null)
    if [ "$PASS_STATUS" = "" ]; then
        echo "Warning: Deck user not found!"
    fi

    if [ "${PASS_STATUS:5:2}" = "NP" ]; then # if no password is set, set up a temporary password to Smash!
        if ( zen_nospam --title="GC Adapter OC Kmod" --width=300 --height=200 --question --text="You appear to have not set an admin password.\nGC Adapter OC Kmod can still install by temporarily setting your password to 'Smash!' and continuing, then removing it when the installer finishes\nAre you okay with that?" ); then
            yes "Smash!" | passwd deck # set password to Smash!
            trap temp_pass_cleanup EXIT # make sure that password is removed when application closes
            PASS="Smash!"
        else exit 1; fi
    else
        # get password
        FINISHED="false"
        while [ "$FINISHED" != "true" ]; do
            PASS=$(zen_nospam --title="GC Adapter OC Kmod" --width=300 --height=100 --entry --hide-text --text="Enter your sudo/admin password")
            if [[ $? -eq 1 ]] || [[ $? -eq 5 ]]; then
                exit 1
            fi
            if ( echo "$PASS" | sudo -S -k true ); then
                FINISHED="true"
            else
                zen_nospam --title="GC Adapter OC Kmod" --width=150 --height=40 --info --text "Incorrect password!"
            fi
        done
    fi

    if ! [ $USER = "deck" ]; then # check if the user is on Deck. If not, provide a warning.
        zen_nospam --title="GC Adapter OC Kmod" --width=300 --height=100 --warning --text "Error: you're likely not using a Steam Deck. Please note this installer will only work said device."
    fi
    
    echo "$PASS" | sudo -S -k bash "$0" "$@" # rerun script as root
    exit 1
fi

# Disable the filesystem until we're done
sudo steamos-readonly disable

# Get pacman keys
sudo pacman-key --init
sudo pacman-key --populate archlinux holo

# Install kernel headers and dev tools
sudo pacman -S --needed --noconfirm base-devel "$(cat /usr/lib/modules/$(uname -r)/pkgbase)-headers"

# Clone repo and change into the directory
git clone https://github.com/hannesmann/gcadapter-oc-kmod.git
cd gcadapter-oc-kmod

# Make the module
make

# Install it
sudo insmod gcadapter_oc.ko

# Persist across reboots
sudo mkdir -p "/usr/lib/modules/$(uname -r)/extra"
sudo cp gcadapter_oc.ko "/usr/lib/modules/$(uname -r)/extra"
sudo depmod
echo "gcadapter_oc" | sudo tee /etc/modules-load.d/gcadapter_oc.conf

# Lock the filesystem back up
sudo steamos-readonly enable

zen_nospam --title="GC Adapter OC Kmod" --width=300 --height=100 --info --text "Installation successful!"
