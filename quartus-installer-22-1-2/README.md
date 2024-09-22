# Quartus Prime Lite 22.1.2 Installer

This is a script to install Quartus Prime Lite 22.1.2 on various Linux distributions including Ubuntu, Debian, Fedora, and Arch Linux (currently only Ubuntu is supported). It will also install the device drivers for USB-Blaster and USB-Blaster II (we hope).

## What it does

- Downloads the Quartus Prime Lite 22.1.2 installer from Intel's website
- Checks for missing dependencies and installs them on your system
- Installs Quartus Prime Lite 22.1.2 to the directory of your choice
- Creates udev rules for USB-Blaster and USB-Blaster II
- Creates a desktop shortcut for Quartus Prime Lite 22.1.2 and QuestaSim
- Handles the license file installation for you (you need to provide the license.dat file)

## Online Installation

### Ubuntu (Works on all versions since 20.04 LTS)

Open a terminal and run the following commands:

```bash
wget -qO- https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/quartus-installer-22-1-2/quartus-lite-22-1-2-ubuntu.sh | bash
```

If 'wget' is not installed, you can install it with the following command:

```bash
curl -s https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/quartus-installer-22-1-2/quartus-lite-22-1-2-ubuntu.sh | bash
```

## Offline Installation

### Ubuntu (Works on all versions since 20.04 LTS)

Open a terminal and run the following commands:

```bash
wget -qO- https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/quartus-installer-22-1-2/quartus-lite-22-1-2-ubuntu.sh
quartus-lite-22-1-2-ubuntu.sh /path/to/installer.tar
```

If 'wget' is not installed, you can install it with the following command:

```bash
curl -s https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/quartus-installer-22-1-2/quartus-lite-22-1-2-ubuntu.sh
quartus-lite-22-1-2-ubuntu.sh /path/to/installer.tar
```

## Tested/Available Distributions

- Ubuntu 24.04 LTS
- Ubuntu 23.10
- Ubuntu 22.04 LTS
- Ubuntu 20.04 LTS

## Wanna see more distros supported or a bug fixed?

If you have tested this script on a distribution not listed above, please open an issue or pull request to update the list. If you find a bug, please open an issue.

> Disclaimer: This script is not affiliated with Intel or Altera in any way. It is provided as-is with no warranty. Use at your own risk.
