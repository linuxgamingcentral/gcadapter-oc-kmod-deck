# GCC Adapter Overclocking Script for Steam Deck
Convenient desktop file for overclocking the GameCube controller adapter on Steam Deck. Should persist across reboots.

Download the [desktop file](https://raw.githubusercontent.com/linuxgamingcentral/gcadapter-oc-kmod-deck/main/install.desktop) (right-click, Save Link As) and run it. Enter your root password when prompted. If a root password is not set up, the installer should temporarily use the password `Smash!` (key word is *should*; I haven't tested without a root password). After installation your GCC adapter should now be overclocked to 1,000 Hz. That's it!

[ocing_gcc_on_deck.webm](https://github.com/linuxgamingcentral/gcadapter-oc-kmod-deck/assets/101075966/7484d587-98b8-4e40-8821-78e72e6556ba)

Video tutorial available on [YouTube](https://www.youtube.com/watch?v=9Vfg3-n8peE).

If you want to uninstall, download the [uninstall desktop file](https://raw.githubusercontent.com/linuxgamingcentral/gcadapter-oc-kmod-deck/main/uninstall.desktop) and repeat the same steps.

See my [guide](https://linuxgamingcentral.com/posts/overclock-gc-adapter-on-steam-deck/) for more info.

This script is in its infant stages. Bugs are to be expected. Please file an [issue](https://github.com/linuxgamingcentral/gcadapter-oc-kmod-deck/issues/new) if you come across any.

*Note: some shell scripting code was borrowed from [Decky Loader](https://github.com/SteamDeckHomebrew/decky-loader).*
