sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S warpinator cpod greenclip obsidian bitwarden qtile piper rofi picom ttf-iosevka-nerd
