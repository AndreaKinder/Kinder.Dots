sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S warpinator cpod greenclip obsidian bitwarden-rofi-git qtile piper picom ttf-iosevka-nerd fslint fslint-gui libinput-gestures lightdm-webkit-theme-aether obsidian piper playerctld-systemd-unit verascrypt yay yay-debug cython2 cython2-debug libglade libglade-debug libinput-gestures lightdm-webkit-theme-aether playerctld-systemd-unit pygtk pygtk-debug python2 python2-cairo python2-cairo-debug python2-gobject2 python2-numpy python2-numpy-debug 
