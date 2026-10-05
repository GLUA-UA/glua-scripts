# Quartus Prime Lite 22.1.2 Installer - Usage Guide

## Installation Methods

The installer supports three installation modes:

### 1. Online Installation (Default)

Downloads from our server.

```bash
./quartus-lite-25-1-ubuntu.sh
```

### 2. Custom URL Installation

Download from a custom URL (local mirror, network server, etc.).

```bash
./quartus-lite-25-1-ubuntu.sh --url <URL>
```

**Examples:**

```bash
# Local network server
./quartus-lite-25-1-ubuntu.sh --url http://192.168.1.100/installer.tar.gz

# Local file server
./quartus-lite-25-1-ubuntu.sh --url http://fileserver.local/quartus/Quartus-lite-25.1std.0.1129-linux.tar.gz

# HTTP server on specific port
./quartus-lite-25-1-ubuntu.sh --url http://192.168.1.50:8080/software/quartus-lite.tar.gz
```

### 3. Offline Installation

Use a pre-downloaded installer file.

```bash
# New syntax
./quartus-lite-25-1-ubuntu.sh --offline /path/to/installer.tar.gz

# Legacy syntax (still supported)
./quartus-lite-25-1-ubuntu.sh /path/to/installer.tar.gz
```

**Examples:**

```bash
# From Downloads folder
./quartus-lite-25-1-ubuntu.sh --offline ~/Downloads/Quartus-lite-25.1std.0.1129-linux.tar

# From USB drive
./quartus-lite-25-1-ubuntu.sh --offline /media/usb/quartus-installer.tar.gz

# From network mount
./quartus-lite-25-1-ubuntu.sh --offline /mnt/network-share/installers/quartus-lite.tar.gz
```
