sudo mkdir -p /etc/udev/rules.d
echo -e 'SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="0666"\nSUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"' | sudo tee /etc/udev/rules.d/51-usbblaster.rules
sudo udevadm control --reload
mkdir -p $TMP_DIR/

if test -f "$TMP_DIR/quartus-lite.tar.gz"; then
    echo "$TMP_DIR/quartus-lite.tar.gz exists. Using provided installer"
else
    echo "Downloading installer from: $DOWNLOAD_URL"
    wget -O $TMP_DIR/quartus-lite.tar.gz "$DOWNLOAD_URL"
fi

tar -xzvf $TMP_DIR/quartus-lite.tar.gz -C $TMP_DIR/
$TMP_DIR/QuartusLiteSetup-25.1std.0.1129-linux.run --mode unattended --installdir $INSTALL_PATH --accept_eula true

if [ -d "$TMP_DIR" ]; then
    rm -rf $TMP_DIR
fi

mkdir -p $HOME/.local/share/applications/

if [[ ! $PATH =~ "$INSTALL_PATH/quartus/bin" ]]; then
    echo 'export PATH=$PATH:'$INSTALL_PATH'/quartus/bin' >> ~/.bashrc
fi
echo -e "[Desktop Entry]\nName=Quartus Prime Lite 25.1\nType=Application\nTerminal=false\nExec=env LM_LICENSE_FILE='$INSTALL_PATH'/questa_license.dat $INSTALL_PATH/quartus/bin/quartus --64bit\nIcon=$INSTALL_PATH/quartus/adm/quartusii.png\nCategories=Development;Electronics;\nHidden=false\nNoDisplay=false\nStartupNotify=false" | tee $HOME_DIR/.local/share/applications/quartus_prime_lite_25_1.desktop

if [[ ! $PATH =~ "$INSTALL_PATH/questa_fse/bin" ]]; then
    echo 'export PATH=$PATH:'$INSTALL_PATH'/questa_fse/bin' >> ~/.bashrc
fi
wget -U GLUA_Quartus_Installer/25.1 -O $INSTALL_PATH/questa_fse/questa.png https://i.imgur.com/vWeka9a.png
echo -e "[Desktop Entry]\nType=Application\nName=Questa 25.1\nComment=Questa Simulation Software\nExec=env SALT_LICENSE_SERVER='$INSTALL_PATH'/questa_license.dat LM_LICENSE_FILE='$INSTALL_PATH'/questa_license.dat  $INSTALL_PATH/questa_fse/bin/vsim -gui -l /dev/null\nIcon=$INSTALL_PATH/questa_fse/questa.png\nTerminal=false\nCategories=Development;Electronics;" | tee $HOME_DIR/.local/share/applications/questa_fse_25_1.desktop

source ~/.bashrc

