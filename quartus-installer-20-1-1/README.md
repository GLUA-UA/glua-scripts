# Quartus Prime Lite 20.1.1 Installer

This is a script to install Quartus Prime Lite 20.1.1 on various Linux distributions including Ubuntu, Debian, Fedora, and Arch Linux (currently only Ubuntu is supported). It will also install the device drivers for USB-Blaster and USB-Blaster II (we hope).

## What it does

- Downloads the Quartus Prime Lite 20.1.1 installer from Intel's website
- Checks for missing dependencies and installs them on your system
- Installs Quartus Prime Lite 20.1.1 to the directory of your choice
- Creates udev rules for USB-Blaster and USB-Blaster II
- Creates a desktop shortcut for Quartus Prime Lite 20.1.1 and ModelSim

## Installation

### Ubuntu (Works on all versions since 20.04 LTS)

Open a terminal and run the following commands:

```bash
wget -qO- https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/quartus-installer-20-1-1/quartus-lite-20-1-1-ubuntu.sh | bash
```

If 'wget' is not installed, you can install it with the following command:

```bash
curl -s https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/quartus-installer-20-1-1/quartus-lite-20-1-1-ubuntu.sh | bash
```

## Tested/Available Distributions

- Ubuntu 23.10
- Ubuntu 22.04 LTS
- Ubuntu 20.04 LTS

## Wanna see more distros supported or a bug fixed?

If you have tested this script on a distribution not listed above, please open an issue or pull request to update the list. If you find a bug, please open an issue.

> Disclaimer: This script is not affiliated with Intel or Altera in any way. It is provided as-is with no warranty. Use at your own risk.
