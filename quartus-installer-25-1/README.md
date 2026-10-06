# Quartus Prime Lite 25.1 Installer

This is a script to install Quartus Prime Lite 25.1 on various Linux distributions including Ubuntu, Debian, Fedora, and Arch Linux (currently only Ubuntu is supported). It will also install the device drivers for USB-Blaster and USB-Blaster II (we hope).

## What it does

- Downloads the Quartus Prime Lite 25.1 installer from our server (or a custom URL)
- Checks for missing dependencies and installs them on your system
- Installs Quartus Prime Lite 25.1 to the directory of your choice
- Creates udev rules for USB-Blaster and USB-Blaster II
- Creates a desktop shortcut for Quartus Prime Lite 25.1 and QuestaSim
- Handles the license file installation for you (you need to provide the license.dat file)

## Installation Methods

### Online Installation (Default Intel URL)

#### Ubuntu (Works on all versions since 20.04 LTS)

Open a terminal and run the following commands:

```bash
wget -qO- https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/quartus-installer-25-1/quartus-lite-25-1-ubuntu.sh | bash
```

If 'wget' is not installed, you can install it with the following command:

```bash
curl -s https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/quartus-installer-25-1/quartus-lite-25-1-ubuntu.sh | bash
```

### Custom URL Installation

You can specify a custom download URL (e.g., from a local mirror or network server) using the `--url` flag:

```bash
./quartus-lite-25-1-ubuntu.sh --url http://192.168.1.100/installer.tar.gz
```

Or download and run in one command:

```bash
wget https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/quartus-installer-25-1/quartus-lite-25-1-ubuntu.sh
chmod +x quartus-lite-25-1-ubuntu.sh
./quartus-lite-25-1-ubuntu.sh --url http://192.168.1.100/installer.tar.gz
```

### Offline Installation

#### Ubuntu (Works on all versions since 20.04 LTS)

If you already have the installer tar file downloaded, you can use the `--offline` flag:

```bash
./quartus-lite-25-1-ubuntu.sh --offline /path/to/installer.tar.gz
```

For backward compatibility, you can also use the original syntax:

```bash
./quartus-lite-25-1-ubuntu.sh /path/to/installer.tar.gz
```

## Tested/Available Distributions

- Ubuntu 26.04 LTS
- Ubuntu 24.04 LTS

## Wanna see more distros supported or a bug fixed?

If you have tested this script on a distribution not listed above, please open an issue or pull request to update the list. If you find a bug, please open an issue.

> Disclaimer: This script is not affiliated with Intel or Altera in any way. It is provided as-is with no warranty. Use at your own risk.
