# GCC Adapter Overclocking Script for Steam Deck
Convenient desktop file for overclocking the GameCube controller adapter on Steam Deck. Should persist across reboots. Overclocking made possible thanks to [hannesmann](https://github.com/HannesMann/gcadapter-oc-kmod).

Set up a root password if you don't already have one with `passwd`. Download the [desktop file](https://raw.githubusercontent.com/linuxgamingcentral/gcadapter-oc-kmod-deck/main/install.desktop) (right-click, Save Link As) and run it. Enter your root password when prompted. After installation your GCC adapter should now be overclocked to 1,000 Hz. That's it!

[ocing_gcc_on_deck.webm](https://github.com/linuxgamingcentral/gcadapter-oc-kmod-deck/assets/101075966/7484d587-98b8-4e40-8821-78e72e6556ba)

Video tutorial available on [YouTube](https://www.youtube.com/watch?v=9Vfg3-n8peE).

See my [guide](https://linuxgamingcentral.com/posts/overclock-gc-adapter-on-steam-deck/) for more info.

This script is in its infant stages. Bugs are to be expected. Please file an [issue](https://github.com/linuxgamingcentral/gcadapter-oc-kmod-deck/issues/new) if you come across any.

## If You're Not Using SteamOS...
As of right now, only the Steam Deck is officially supported. That being said, there is partial support for distros outside of SteamOS. You will need the following packages installed first:
- base development tools (`base-devel` if you're on Arch, `build-essential` on Ubuntu)
- Linux headers appropriate to the current kernel you're running

If you don't have these packages installed you won't be able to compile the overclock module.

After that you can run the script with:

`curl -L https://raw.githubusercontent.com/linuxgamingcentral/gcadapter-oc-kmod-deck/main/install_gcadapter-oc-kmod.sh | sh`

## Version differences
### 0.0.2 (1/5/2024)
- user now has the ability to uninstall if the overclocked module already exists
- added partial support for distros outside of SteamOS
### 0.0.1
- initial release
