sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install libcanberra-gtk-module libcanberra-gtk3-module libxft2:i386 libxext6:i386 libncurses5:i386 bzip2:i386 -y
sudo apt-get install g++-multilib -y
sudo mkdir -p /etc/udev/rules.d
echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"' | sudo tee /etc/udev/rules.d/51-usbblaster.rules
sudo udevadm control --reload
mkdir -p /tmp/quartus-prime-lite-installer-22-1-2/

if test -f "/tmp/quartus-prime-lite-installer-22-1-2/quartus-lite.tar"; then
    echo "$FILE exists. Using provided installer"
else
    wget -O /tmp/quartus-prime-lite-installer-22-1-2/quartus-lite.tar https://downloads.intel.com/akdlm/software/acdsinst/22.1std.2/922/ib_tar/Quartus-lite-22.1std.2.922-linux.tar
fi

tar -xvf /tmp/quartus-prime-lite-installer-22-1-2/quartus-lite.tar -C /tmp/quartus-prime-lite-installer-22-1-2/
/tmp/quartus-prime-lite-installer-22-1-2/components/QuartusLiteSetup-22.1std.2.922-linux.run --mode unattended --installdir $INSTALL_PATH --accept_eula true $(build_disabled_components_flag)
rm -rf /tmp/quartus-lite-installer-22-1-2/ : DISABLED FOR DEBUGGING
mkdir -p $HOME/.local/share/applications/
if [ "$QUARTUS_ENABLE" == "true" ]; then
    if [[ ! $PATH =~ "$INSTALL_PATH/quartus/bin" ]]; then
        echo 'export PATH=$PATH:'$INSTALL_PATH'/quartus/bin' >> ~/.bashrc
    fi
    echo -e "[Desktop Entry]\nName=Quartus Prime Lite 22.1.2\nType=Application\nTerminal=false\nExec=env LM_LICENSE_FILE='$INSTALL_PATH'/questa_license.dat $INSTALL_PATH/quartus/bin/quartus --64bit\nIcon=$INSTALL_PATH/quartus/adm/quartusii.png\nCategories=Development;Electronics;\nHidden=false\nNoDisplay=false\nStartupNotify=false" | tee $HOME_DIR/.local/share/applications/quartus_prime_lite_22_1_2.desktop
fi

if [ "$QUESTA_FSE_ENABLE" == "true" ]; then
    if [[ ! $PATH =~ "$INSTALL_PATH/questa_fse/bin" ]]; then
        echo 'export PATH=$PATH:'$INSTALL_PATH'/questa_fse/bin' >> ~/.bashrc
    fi
    wget -O $INSTALL_PATH/questa_fse/questa.png https://i.imgur.com/vWeka9a.png
    echo -e "[Desktop Entry]\nType=Application\nName=Questa 22.1.2\nComment=Questa Simulation Software\nExec=env LM_LICENSE_FILE='$INSTALL_PATH'/questa_license.dat  $INSTALL_PATH/questa_fse/bin/vsim -gui -l /dev/null\nIcon=$INSTALL_PATH/questa_fse/questa.png\nTerminal=false\nCategories=Development;Electronics;" | tee $HOME_DIR/.local/share/applications/questa_fse_22_1_2.desktop
fi
source ~/.bashrc

