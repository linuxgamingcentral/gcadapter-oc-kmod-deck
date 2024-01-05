#!/bin/bash

clear

echo -e "GCC Adapter Overclocking script by Linux Gaming Central.\n"
sleep 1

title="GC Adapter OC Kmod"

# Removes unhelpful GTK warnings
zen_nospam() {
  zenity 2> >(grep -v 'Gtk' >&2) "$@"
}

info() {
	text=$1
	zen_nospam --title="$title" --width=300 --height=100 --info --text "$1"
}

question() {
	text=$1
	zen_nospam --title="$title" --width=300 --height=200 --question --text="$1"
}

install_overclock_module() {
	echo -e "Cloning repo...\n"
	sleep 1
	git clone https://github.com/hannesmann/gcadapter-oc-kmod.git
	cd gcadapter-oc-kmod

	echo -e "Compiling...\n"
	sleep 1
	make

	echo -e "Installing  module...\n"
	sleep 1
	sudo -Sp '' insmod gcadapter_oc.ko <<<${sudo_password}

	echo -e "Persisting across reboots...\n"
	sleep 1
	sudo mkdir -p "/usr/lib/modules/$(uname -r)/extra"
	sudo cp gcadapter_oc.ko "/usr/lib/modules/$(uname -r)/extra"
	sudo depmod
	echo "gcadapter_oc" | sudo tee /etc/modules-load.d/gcadapter_oc.conf
	
	echo -e "Success!\n"
	sleep 1
}

uninstall() {
	cd gcadapter-oc-kmod/
	
	echo -e "Removing module...\n"
	sleep 1
	sudo -Sp '' rmmod gcadapter_oc.ko <<<${sudo_password}
	
	echo -e "Cleaning up...\n"
	sleep 1
	make clean
	
	echo -e "Deleting configuration...\n"
	sleep 1
	sudo rm /usr/lib/modules/$(uname -r)/extra/gcadapter_oc.ko
	sudo rm /etc/modules-load.d/gcadapter_oc.conf
	
	echo -e "Success!\n"
	sleep 1
}

# Check if GitHub is reachable
if ! curl -Is https://github.com | head -1 | grep 200 > /dev/null
then
    echo "GitHub appears to be unreachable, you may not be connected to the Internet."
    exit 1
fi

# check to see if user is using SteamOS. If not, provide a warning
if [ $USER == "deck" ]; then
	echo -e "User is using SteamOS.\n"
else
	info "You're using a distro that isn't supported by this program. The program will continue to operate, but you may get issues along the way."
fi

# get sudo password
sudo_password=$(zen_nospam --password --title="$title")
if [[ ${?} != 0 || -z ${sudo_password} ]]; then
	echo -e "User canceled.\n"
	exit
elif ! sudo -kSp '' [ 1 ] <<<${sudo_password} 2>/dev/null; then
	echo -e "User entered wrong password.\n"
	info "Wrong password."
	exit
else
	echo -e "Password entered, let's proceed...\n"
	sleep 1
fi

mkdir -p $HOME/Applications
cd $HOME/Applications

# check to see if overclock module already exists. If it does, offer the user to uninstall
if [ -f /usr/lib/modules/$(uname -r)/extra/gcadapter_oc.ko ]; then
	if ( question "Overclock module already installed. Would you like to uninstall?" ); then
	yes |
		if [ $USER == "deck" ]; then
			echo -e "Disabling read-only file system...\n"
			sleep 1
			sudo -Sp '' steamos-readonly disable <<<${sudo_password}
			echo -e "Unlocked!\n"
			sleep 1
			
			uninstall
			
			echo -e "Restoring read-only file system...\n"
			sleep 1
			sudo steamos-readonly enable
			echo -e "Restored!\n"
			sleep 1
							
			info "Overclock module removed!"
		else
			uninstall
			
			info "Overclock module removed!"
		fi
	else
		exit
	fi
else
	# overclock on Deck
	if [ $USER == "deck" ]; then
		echo -e "Disabling read-only file system...\n"
		sleep 1
		sudo -Sp '' steamos-readonly disable <<<${sudo_password}

		echo -e "Populating pacman keys...\n"
		sleep 1
		sudo pacman-key --init
		sudo pacman-key --populate archlinux holo

		echo -e "Installing base development tools and Linux headers...\n"
		sleep 1
		sudo pacman -S --needed --noconfirm base-devel "$(cat /usr/lib/modules/$(uname -r)/pkgbase)-headers"
		
		install_overclock_module

		echo -e "Restoring read-only file system...\n"
		sleep 1
		sudo steamos-readonly enable

		info "Installation complete!"
		exit
	# other distros
	else
		install_overclock_module
		info "Installation complete!"
		exit
	fi
fi
