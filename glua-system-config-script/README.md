# System Configuration Script

![GLUA Logo](https://glua.ua.pt/assets/img/logo.svg)

**Note: only works for [Ubuntu](https://ubuntu.com/)**

## Running the script
Script used to configure the system post-installation.

You can run the script by running:

```console
wget https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/glua-system-config-script/glua-system-config-script.sh
sudo bash install.sh
```

When running, you will be prompted to select a configuration option:

![Prompt Example](https://raw.githubusercontent.com/GLUA-UA/glua-scripts/main/glua-system-config-script/assets/config-option-example.png)

You can select the option that best suits you:

1. **Full install**
	- Add [GLUA mirrors](https://glua.ua.pt/pub/) to the mirror list, update the system and install some useful tools;
2. **Full install with NVIDIA drivers**
	- Same as `Full install` but will also install needed drivers by newer NVIDIA graphic cards;
3. **Install NVIDIA drivers**
	- Install needed drivers by newer NVIDIA graphic cards.

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