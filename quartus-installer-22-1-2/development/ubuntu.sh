sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install libcanberra-gtk-module libcanberra-gtk3-module libxft2:i386 libxext6:i386 libncurses5:i386 bzip2:i386 -y
sudo apt-get install g++-multilib -y
sudo mkdir -p /etc/udev/rules.d
echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"' | sudo tee /etc/udev/rules.d/51-usbblaster.rules
sudo udevadm control --reload
mkdir -p /tmp/quartus-prime-lite-installer-22-1-2/
## TODO: UPDATE THESE LINKS TO CHECK FOR NEWER VERSIONS
#wget -O /tmp/quartus-prime-lite-installer-22-1-2/quartus-lite.tar https://downloads.intel.com/akdlm/software/acdsinst/20.1std.1/720/ib_tar/Quartus-lite-20.1.1.720-linux.tar
tar -xvf /tmp/quartus-prime-lite-installer-22-1-2/quartus-lite.tar -C /tmp/quartus-prime-lite-installer-22-1-2/
#/tmp/quartus-prime-lite-installer-20-1-1/components/QuartusLiteSetup-20.1.1.720-linux.run --mode unattended --installdir $INSTALL_PATH --accept_eula true $(build_disabled_components_flag)
#rm -rf /tmp/quartus-lite-installer-20-1-2/ : DISABLED FOR DEBUGGING
mkdir -p $HOME/.local/share/applications/
if [ "$QUARTUS_ENABLE" == "true" ]; then
    if [[ ! $PATH =~ "$INSTALL_PATH/quartus/bin" ]]; then
        echo 'export PATH=$PATH:'$INSTALL_PATH'/quartus/bin' >> ~/.bashrc
    fi
    echo -e "[Desktop Entry]\nName=Quartus Prime Lite 22.1.2\nType=Application\nTerminal=false\nExec=$INSTALL_PATH/quartus/bin/quartus --64bit\nIcon=$INSTALL_PATH/quartus/adm/quartusii.png\nCategories=Development;Electronics;\nHidden=false\nNoDisplay=false\nStartupNotify=false" | tee $HOME_DIR/.local/share/applications/quartus_prime_lite_22_1_2.desktop
fi
## TODO: UPDATE THIS FUNCTION TO CHECK FOR NEWER VERSIONS
#if [ "$MODELSIM_ASE_ENABLE" == "true" ]; then
#    if [[ ! $PATH =~ "$INSTALL_PATH/modelsim_ase/bin" ]]; then
#        echo 'export PATH=$PATH:'$INSTALL_PATH'/modelsim_ase/bin' >> ~/.bashrc
#    fi
#    wget -O $INSTALL_PATH/modelsim_ase/modelsim.png https://i.imgur.com/vWeka9a.png
#    echo -e "[Desktop Entry]\nType=Application\nName=ModelSim ASE 20.1.1\nComment=ModelSim Simulation Software\nExec=$INSTALL_PATH/modelsim_ase/bin/vsim -gui -l /dev/null\nIcon=$INSTALL_PATH/modelsim_ase/modelsim.png\nTerminal=false\nCategories=Development;Electronics;" | tee $HOME_DIR/.local/share/applications/modelsim_ase_20_1_1.desktop
#fi
source ~/.bashrc