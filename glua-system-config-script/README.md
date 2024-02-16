# System Configuration Script

![GLUA Logo](https://glua.ua.pt/assets/img/logo.svg)

**Note: only works for [Ubuntu](https://ubuntu.com/)**

## Running the script
Script used to configure the system post-installation.

You can run the script by running:

```console
wget https://glua.ua.pt/lip/install.sh
sudo bash install.sh
```

When running, you will be prompted to select a configuration option, select the one best suited for you:

1. **Full install**
    - Runs the full setup:
        + Adds [GLUA mirrors](https://glua.ua.pt/pub/) to the mirror list;
        + Updates the system;
        + Installs some extra software;
        + Installs extra drivers (Optional);
        + Sets Windows as first boot option (Optional);
        + Sets up UA VPN (Optional).
2. **Setup mirrors and system update**
    - Adds [GLUA mirrors](https://glua.ua.pt/pub/) to the mirror list and updates the system.
3. **Install NVIDIA drivers**
	- Install needed drivers by newer NVIDIA graphic cards.
4. **Set windows as first boot option**
	- Makes Windows appear on top of Ubuntu in grub boot menu.
5. **Set up university vpn**
    - Sets up university's checkpoint VPN (`snx`).

### Packages installed during `Full install`
- curl
- vim
- build-essential
- git
- gitg
- openjdk-17-jdk
- ubuntu-restricted-extras
