#!/bin/bash

# If a password was set by the program, this will run when the program closes
temp_pass_cleanup() {
  echo $PASS | sudo -S -k passwd -d deck
}

# Removes unhelpful GTK warnings
zen_nospam() {
  zenity 2> >(grep -v 'Gtk' >&2) "$@"
}

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
        zen_nospam --title="GC Adapter OC Kmod" --width=300 --height=100 --warning --text "Error: you're likely not using a Steam Deck. Please note this uninstaller will only work said device."
    fi
    
    echo "$PASS" | sudo -S -k bash "$0" "$@" # rerun script as root
    exit 1
fi

sudo steamos-readonly disable

cd /tmp/gcadapter-oc-kmod/
sudo rmmod gcadapter_oc.ko
make clean
sudo rm gcadapter_oc.ko "/usr/lib/modules/$(uname -r)/extra/"
sudo rm /etc/modules-load.d/gcadapter_oc.conf

sudo steamos-readonly enable

zen_nospam --title="GC Adapter OC Kmod" --width=300 --height=100 --info --text "Uninstallation successful!"
