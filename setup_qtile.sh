#!/bin/bash

# Update the system
sudo pacman -Syu

# Install LightDM
sudo pacman -S lightdm qtile lightdm-gtk-greeter


# Enable LightDM to start automatically on boot
sudo systemctl enable lightdm
sudo systemctl enable lightdm.service

# Configure LightDM to start Qtile
sudo sed -i 's/#session=/session=qtile/' /etc/lightdm/lightdm.conf

# Reboot the system
sudo reboot
