# Quartus Prime Lite 22.1.2 Installer - Usage Guide

## Installation Methods

The installer supports three installation modes:

### 1. Online Installation (Default)

Downloads from Intel's official servers.

```bash
./quartus-lite-22-1-2-ubuntu.sh
```

### 2. Custom URL Installation

Download from a custom URL (local mirror, network server, etc.).

```bash
./quartus-lite-22-1-2-ubuntu.sh --url <URL>
```

**Examples:**

```bash
# Local network server
./quartus-lite-22-1-2-ubuntu.sh --url http://192.168.1.100/installer.tar

# Local file server
./quartus-lite-22-1-2-ubuntu.sh --url http://fileserver.local/quartus/Quartus-lite-22.1std.2.922-linux.tar

# HTTP server on specific port
./quartus-lite-22-1-2-ubuntu.sh --url http://192.168.1.50:8080/software/quartus-lite.tar
```

### 3. Offline Installation

Use a pre-downloaded installer file.

```bash
# New syntax
./quartus-lite-22-1-2-ubuntu.sh --offline /path/to/installer.tar

# Legacy syntax (still supported)
./quartus-lite-22-1-2-ubuntu.sh /path/to/installer.tar
```

**Examples:**

```bash
# From Downloads folder
./quartus-lite-22-1-2-ubuntu.sh --offline ~/Downloads/Quartus-lite-22.1std.2.922-linux.tar

# From USB drive
./quartus-lite-22-1-2-ubuntu.sh --offline /media/usb/quartus-installer.tar

# From network mount
./quartus-lite-22-1-2-ubuntu.sh --offline /mnt/network-share/installers/quartus-lite.tar
```
