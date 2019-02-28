# Ubuntu Mirrors Script

![GLUA Logo](https://glua.ua.pt/assets/img/logo.svg)

Automatic Ubuntu release detection and `sources.list` file update. 
This file uses the [mirror service ](https:/glua.ua.pt/pub) of Grupo Linux da Universidade de Aveiro (GLUA) .

To add our mirrored repositories to your system, open a terminal and backup your sources.list file:
```bash
$ sudo cp /etc/apt/sources.list /etc/apt/source.list.bak
```
Next download the script to detect if your distro is available in our mirrors:

```bash
$ wget https://raw.githubusercontent.com/GLUA-UA/UbuntuMirrorsScript/master/glua_mirrors_ubuntu.sh
```
After doing so, you will need to run the script to update your `sources.list` file:

```bash
$ sudo bash glua_mirrors_ubuntu.sh
```
If you get the message "Release não disponível nos mirrors", we don't have the desired release 😟  in our mirrors. Otherwise you can proceed to the next step.

Finally update apt-get's index files:
```bash
$ sudo apt-get update
```
Congratulations! Your system is now ready to use our mirrored repositories.


Notes:
The example above is for the version 14.04 and above of Ubuntu/Kubuntu/Xubuntu.
