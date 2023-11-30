#!/bin/bash

# if the script is not root yet, get the password and rerun as root
if (( $EUID != 0 )); then
    PASS_STATUS=$(passwd -S deck 2> /dev/null)

    if [ "${PASS_STATUS:5:2}" = "NP" ]; then # if no password is set, exit
        if ( zen_nospam --title="GC Adapter OC Kmod Installer" --width=300 --height=200 --question --text="No root password set. Please set up a root password before installation by running passwd from a terminal." ); then
        exit 1; fi
    else
        # get password
        FINISHED="false"
        while [ "$FINISHED" != "true" ]; do
            PASS=$(zen_nospam --title="GC Adapter OC Kmod Installer" --width=300 --height=100 --entry --hide-text --text="Enter your sudo/admin password")
            if [[ $? -eq 1 ]] || [[ $? -eq 5 ]]; then
                exit 1
            fi
            if ( echo "$PASS" | sudo -S -k true ); then
                FINISHED="true"
            else
                zen_nospam --title="GC Adapter OC Kmod Installer" --width=150 --height=40 --info --text "Incorrect Password"
            fi
        done
    fi
    
    echo "$PASS" | sudo -S -k bash "$0" "$@" # rerun script as root
    exit 1
fi

# Disable the filesystem
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

# Re-enable readonly filesystem
sudo steamos-readonly enable

echo "100" ; echo "# Install finished, installer can now be closed";
) |
zen_nospam --progress \
  --title="GC Adapter OC Kmod" \
  --width=300 --height=100 \
  --text="Installing..." \
  --percentage=0 \
  --no-cancel # not actually sure how to make the cancel work properly, so it's just not there unless someone else can figure it out

if [ "$?" = -1 ] ; then
        zen_nospam --title="GC Adapter OC Kmod" --width=150 --height=70 --error --text="Download interrupted."
fi
