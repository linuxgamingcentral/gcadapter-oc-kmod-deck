# GCC Adapter Overclocking Script for Steam Deck
Convenient desktop file for overclocking the GameCube controller adapter on Steam Deck. Should persist across reboots.

Download the [desktop file](https://raw.githubusercontent.com/linuxgamingcentral/gcadapter-oc-kmod-deck/main/install.desktop) (right-click, Save Link As) and run it. Enter your root password when prompted. If a root password is not set up, the installer should temporarily use the password `Smash!` (key word is *should*; I haven't tested without a root password). After installation your GCC adapter should now be overclocked to 1,000 Hz. That's it!

If you want to uninstall, download the [desktop file](https://raw.githubusercontent.com/linuxgamingcentral/gcadapter-oc-kmod-deck/main/uninstall.desktop) and repeat the same steps.

See my [guide](https://linuxgamingcentral.com/posts/overclock-gc-adapter-on-steam-deck/) for more info.

This script is in its infant stages. Bugs are to be expected. Please file an [issue](https://github.com/linuxgamingcentral/gcadapter-oc-kmod-deck/issues/new) if you come across any.

*Note: some shell scripting code was borrowed from [Decky Loader](https://github.com/SteamDeckHomebrew/decky-loader).*
