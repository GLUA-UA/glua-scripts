#!/bin/bash

# ------------------- Description -------------------

# Exit if ran using sh
if [ ! "$BASH_VERSION" ] ; then
    printf "\033[0;31mPlease run the script using 'bash' instead of 'sh'\033[0m\n"
    exit
fi

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" || exit ; pwd -P )
cd "$parent_path" || exit

# Check if the user is running Ubuntu
if [[ $(cat /etc/os-release) != *"ID=ubuntu"* ]]; then
    echo -e "\033[0;31mYou can only run this script in Ubuntu\033[0m"
    exit
fi

# Check if the user is root
if [ "$EUID" -ne 0 ]; then
    echo -e "\033[0;31mPlease run the script as root\033[0m"
    exit
fi

echo -e "\033[0;33mWelcome To GLUA's system configuration script"
echo -e "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMmdyyssssyhdNMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMNy+////////////odMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMh+////////////////sMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMh///////////////////sMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMm/////////////////////hMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMy//////////////////////NMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMy//////////////////////yMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMy//////////////////////sMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMs///////////////////////+hNMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMm//////////////////////////+sdMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMo/////////////////////////////+dMMMMMMMMMM
MMMMMMMMMMMMMMMMMy//////////////////////////++oooyMMMMMMMMMM
MMMMMMMMMMMMMMMMh/////////////////////////omNNNNMMMMMMMMMMMM
MMMMMMMMMMMMMMNy///////////////////////////dMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMd+/////////////////////////////mMMMMMMMMMMMMMMM
MMMMMMMMMMMNs///////////////////////////////+MMMMMMMMMMMMMMM
MMMMMMMMMMNo/////////////////////////////////mMMMMMMMMMMMMMM
MMMMMMMMMMo//////////////////////////////////sMMMMMMMMMMMMMM
MMMMMMMMMy////////////////////////////////////hMMMMMMMMMMMMM
MMMMMMMMN/////////////////////////////////////+MMMMMMMMMMMMM
MMMMMMMMh//////////////////////////////////////hMMMMMMMMMMMM
MMMMMMMMo//////////////////////////////////////oMMMMMMMMMMMM
MMMMMMMM////////////////////////////////////////MMMMMMMMMMMM
MMMMMMMN////////////////////////////////////////NMMMMMMMMMMM
MMMMMMMm////////////////////////////////////////NMMMMMMMMMMM
MMMMMMMm////////////////////////////////////////NMMMMMMMMMMM
MMMMMMMN////////////////////////////////////////NNMMMMMMMMMM
MMMMMMMN/////////////////////////////////////////+NNMMMMMMMM
MMMMMMMM+/////////////////////////////////////////+yMMMMMMMM
MMMMMMMMs////////////////////////////////////////dNMMMMMMMMM
MMMMMMMMh////////////////////////////////////+///dMMMMMMMMMM
MMMMMMMMN///////////////////////////////////hNmmNMMMMMMMMMMM
MMMMMMMMs///////////////////////////////////////oNMMMMMMMMMM
MMMMMMMMooooo+//////////////////////////////////sNMMMMMMMMMM
MMMMMMMMMMMMMMMNNmmmddddhhhhhhddmNNMmy///////////oMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNy/////dMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMdsosMMMMMMMMMMMMMMM\033[0m"

# ------------------- End of Description -------------------

# ------------------- Config functions -------------------

# Configures GLUA's mirrors
config_mirrors() {
    echo -e "\033[0;33mConfiguring mirrors\033[0m"
    wget https://glua.ua.pt/lip/mirrors.sh -P /tmp
    sudo bash /tmp/mirrors.sh
}

# Updates the system
system_update() {
    echo -e "\033[0;33mChecking for system updates\033[0m"
    sudo apt update -y

    echo -e "\033[0;33mInstaling available updates\033[0m"
    sudo apt upgrade -y
}

# Configures the university's VPN
config_vpn() {
    echo -e "\033[0;33mStarting VPN configuration\033[0m"
    sudo dpkg --add-architecture i386
    sudo apt update -y

    echo -e "\033[0;33mInstalling snx dependencies\033[0m"
    sudo apt install -y curl libpam0g:i386 libx11-6:i386 libstdc++6:i386 libstdc++5:i386 libnss3-tools

    echo -e "\033[0;33mDownloading and running snx install script\033[0m"
    cd /tmp || exit
    wget -O snx_install_script.zip https://www.ua.pt/file/60626 && unzip -q snx_install_script.zip
    sudo bash snx_install_linux30.sh

    echo -e "\033[0;33mCleaning up\033[0m"
    cd "$OLDPWD" || exit

    printf "server go.ua.pt\nusername %s\nreauth yes\n" "$1" > "/home/$SUDO_USER/.snxrc"
}

# Installs extra software
install_extra_software() {
    echo -e "\033[0;33mInstalling extra software\033[0m"
    sudo apt install -y curl vim build-essential git gitg openjdk-17-jdk ubuntu-restricted-extras

    echo -e "\033[0;33mFixing groups\033[0m"
    sudo usermod -aG dialout "$(whoami)"
}

# Installs NVIDIA drivers for newer GPUs
install_nvidia_drivers() {
    echo -e "\033[0;33mInstalling NVIDIA drivers\033[0m"
    sudo apt install -y nvidia-driver-580-open nvidia-dkms-580-open
}

# Sets Windows as the first boot entry in grub
set_windows_as_default() {
    echo -e "\033[0;33mSetting Windows as the first boot entry\033[0m"
    sudo mv /etc/grub.d/30_os-prober /etc/grub.d/07_os-prober
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

# ------------------- End of config functions -------------------

# ------------------- Main -------------------

# Check if zenity is installed and install it if not
if ! [ -x "$(command -v zenity)" ]; then
    echo -e "\033[0;33mInstalling zenity\033[0m"
    sudo apt update -y
    sudo apt install -y zenity
fi

# Menu to choose the config_option
config_option=$(zenity --list \
    --title="GLUA's system configuration script" \
    --column="Selected the config option" \
    "Full install" \
    "Setup mirrors and update system" \
    "Install NVIDIA drivers" \
    "Set Windows as first boot option" \
    "Set up university vpn" \
    --width=500 --height=400)

# Check if the user selected an option
if [ -z "$config_option" ]; then
    echo -e "\033[0;31mNo option selected. Exiting...\033[0m"
    exit
fi

echo -e "\033[0;33mSelected option: $config_option\033[0m"

if [ "$config_option" = "Setup mirrors and update system" ]; then
    config_mirrors
    system_update
    echo -e "\033[0;33mSystem updated with GLUA mirrors"
    exit
fi

if [ "$config_option" = "Install NVIDIA drivers" ]; then
    sudo apt update -y
    install_nvidia_drivers
    echo -e "\033[0;33mDrivers installed.\033[0m"
    exit
fi

if [ "$config_option" = "Set windows as first boot option" ]; then
    set_windows_as_default
    echo -e "\033[0;33mWindows is now set as the first boot entry.\033[0m"
    exit
fi

if [ "$config_option" = "Set up university vpn" ]; then
    echo -e "\033[0;33mYour university email:\033[0m"
    ua_vpn_email=$(zenity --entry \
        --title="VPN Configuration" \
        --text="Enter your university email:" \
        --width=500)
    config_vpn "$ua_vpn_email"
    echo -e "\033[0;33mVpn is now configured run snx to start a session.\033[0m"
    exit
fi

zenity --question \
    --title="NVIDIA drivers" \
    --text="Would you like to install NVIDIA drivers?"
install_nvidia_drivers=$?

zenity --question \
    --title="Grub boot order" \
    --text="Would you like to set Windows as the first boot entry?"
change_boot_order=$?

ua_vpn_email=$(zenity --entry \
    --title="VPN Configuration" \
    --text="Enter your university email or leave blank to skip VPN configuration:" \
    --width=500)

config_mirrors
system_update
install_extra_software

if [ "$install_nvidia_drivers" = "0" ]; then
    install_nvidia_drivers
fi

if [ "$change_boot_order" = "0" ]; then
    set_windows_as_default
fi

# Check if the user entered an email for the vpn
# If so, configure the vpn
if [ -n "$ua_vpn_email" ]; then
    config_vpn "$ua_vpn_email"
fi

echo -e "\033[0;33mInstallation done.\033[0m"
# ------------------- End of Main -------------------
