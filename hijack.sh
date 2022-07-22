#!/bin/bash

# Confirm the user wishes to install Rolling Rhino Remix
read -p "Do you wish to install Rolling Rhino Remix onto your system? This action CANNOT be undone [y/N] " confirmation
if [[ $confirmation =~ ^[Yy]$ ]]; then
    echo "Beginning installation..."
    # Update packages
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get autopurge -y 
    sudo apt-get clean -y
    # Clone assets folder
    mkdir -p ~/creation/assets && cd ~/creation || exit
    git clone https://github.com/rollingrhinoremix/assets ~/creation/assets
    # Move all required assets to the correct directories
    sudo mv ~/creation/assets/rolling_rhino.png /usr/share/backgrounds
    sudo mv ~/creation/assets/rolling_rhino-dark.png /usr/share/backgrounds
    mv ~/creation/assets/.bash_aliases ~
    mv ~/creation/assets/.bashrc ~
    sudo rm -rf /usr/share/glib-2.0/schemas/10_ubuntu-settings.gschema.override
    sudo mv ~/creation/assets/10_ubuntu-settings.gschema.override /usr/share/glib-2.0/schemas
    # Create distribution configuration files
    mkdir -p ~/.rhino/{updates,config} 
    touch ~/.rhino/updates/configuration
    touch ~/.rhino/updates/config-v2
    # Install rhino-config onto system 
    mkdir ~/creation/rhino-config
    cd ~/creation/rhino-config
    wget -q https://github.com/rollingrhinoremix/rhino-config/releases/latest/download/rhino-config
    chmod +x ~/creation/rhino-config/rhino-config
    sudo mv ~/creation/rhino-config/rhino-config /usr/bin
    # Install rhino-deinst onto system
    mkdir ~/creation/rhino-deinst
    cd ~/creation/rhino-deinst
    wget -q https://github.com/rollingrhinoremix/rhino-deinst/releases/latest/download/rhino-deinst
    chmod +x ~/creation/rhino-deinst/rhino-deinst
    sudo mv ~/creation/rhino-deinst/rhino-deinst /usr/bin
    # Install the latest Linux kernel (from Ubuntu mainline repositories)
    mkdir ~/creation/kernel
    cd ~/creation/kernel
    wget -q --show-progress --progress=bar:force https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.18.13/amd64/linux-headers-5.18.13-051813-generic_5.18.13-051813.202207220940_amd64.deb
    wget -q --show-progress --progress=bar:force https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.18.13/amd64/linux-headers-5.18.13-051813_5.18.13-051813.202207220940_all.deb
    wget -q --show-progress --progress=bar:force https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.18.13/amd64/linux-image-unsigned-5.18.13-051813-generic_5.18.13-051813.202207220940_amd64.deb
    wget -q --show-progress --progress=bar:force https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.18.13/amd64/linux-modules-5.18.13-051813-generic_5.18.13-051813.202207220940_amd64.deb
    sudo apt install ./*.deb -y
    # Clean up system files
    sudo apt-get clean -y
    sudo sed -i 's/kinetic/devel/g' /etc/apt/sources.list
    sudo sed -i 's/kinetic/devel/g' /etc/lsb-release
    sudo sed -i 's/kinetic/devel/g' /usr/lib/os-release
    # So much release info that are mostly same!
    sudo sed -i 's/PRETTY_NAME="Ubuntu Kinetic Kudu (development branch)"/PRETTY_NAME="Rolling Rhino Remix"/g' /etc/os-release
    sudo sed -i 's%HOME_URL="https://www.ubuntu.com/"%HOME_URL="https://www.rollingrhino.org"%g' /etc/os-release
    sudo apt-get --allow-releaseinfo-change update -y
    sudo apt-get --allow-releaseinfo-change dist-upgrade -y
    sudo apt-get autopurge -y
    sudo apt-get clean -y
    # Perform Devel system upgrade
    sudo apt-get update -y 
    sudo apt-get upgrade -y 
    sudo apt-get autopurge -y
    sudo apt-get clean -y
else
    echo "Got it, cancelling"
fi
