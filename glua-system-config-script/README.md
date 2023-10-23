# System Configuration Script

![GLUA Logo](https://glua.ua.pt/assets/img/logo.svg)

**Note: only works for [Ubuntu](https://ubuntu.com/)**

## Running the script
Script used to configure the system post-installation.

You can run the script by running:

```console
wget -qO- https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/glua-system-config-script/glua-system-config-script.sh | sudo bash 
```

When running, you will be prompted to select a configuration option, select the one best suited for you:

1. **Full install**
	- Add [GLUA mirrors](https://glua.ua.pt/pub/) to the mirror list, update the system and install some useful tools;
2. **Install NVIDIA drivers**
	- Install needed drivers by newer NVIDIA graphic cards.
3. **Set windows as first boot option**
	- Makes Windows appear on top of Ubuntu in grub boot menu

### Packages installed during `Full install`
- curl
- vim
- build-essential
- git
- gitk
- default-jdk
- geany
- wireshark
- ubuntu-restricted-extras
