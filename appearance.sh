#!/bin/bash


sudo dnf install gnome-tweaks yaru-theme



# # install extensions
# gnome-extensions install user-theme@gnome-shell-extensions.gcampax.github.com
# gnome-extensions install quake-terminal@diegodario88.github.io
# gnome-extensions install dash-to-dock@micxgx.gmail.com
# gnome-extensions install search-light@icedman.github.com
# gnome-extensions install vscode-search-provider@mrmarble.github.com
# gnome-extensions install bilingual-app-search@pwa.lu
# gnome-extensions install BrowserSearchProvider@mepowerleo10.github.io
# gnome-extensions install apps-menu@gnome-shell-extensions.gcampax.github.com
# gnome-extensions install background-logo@fedorahosted.org
# gnome-extensions install launch-new-instance@gnome-shell-extensions.gcampax.github.com
# gnome-extensions install places-menu@gnome-shell-extensions.gcampax.github.com
# gnome-extensions install window-list@gnome-shell-extensions.gcampax.github.com
# gnome-extensions install color-picker@tuberry
# gnome-extensions install tophat@fflewddur.github.io
# gnome-extensions install top-bar-organizer@julian.gse.jsts.xyz
# gnome-extensions install PrivacyMenu@stuarthayhurst
# gnome-extensions install emoji-copy@felipeftn
# gnome-extensions install always-indicator@martin.zurowietz.de
# gnome-extensions install blur-my-shell@aunetx
# gnome-extensions install clipboard-indicator@tudmotu.com
# gnome-extensions install mediacontrols@cliffniff.github.com



# custom grub
git clone https://github.com/vinceliuice/Elegant-grub2-themes.git
sudo ./Elegant-grub2-themes/install.sh  -s 2k -p window 
rm -rf ./Elegant-grub2-themes