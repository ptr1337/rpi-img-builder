## Image Builder for the Raspberry Pi | Xfce Edition
### This branch is under testing so build at ur own risk.

The boards and distributions that are currently supported;
* Raspberry Pi 4B/400 (bcm2711) | Debian Bullseye

## Progress
Currently I'm using [Mesa 20.3](https://gitlab.freedesktop.org/mesa/mesa/-/archive/20.3/mesa-20.3.tar.gz) (frankenbuild). [MPV](https://mpv.io/) can do full screen play back at 720p/1080p (x264). Test images can be
found under the [release](https://github.com/pyavitz/rpi-img-builder/releases/tag/images) section.

![Screeenshot](https://i.imgur.com/Hqnr0gX.png)

## Dependencies

In order to install the required dependencies, run the following command:

```
sudo apt install build-essential bison bc git dialog patch dosfstools zip unzip qemu \
	debootstrap qemu-user-static rsync kmod cpio flex libssl-dev libncurses5-dev \
	parted device-tree-compiler libfdt-dev python3-distutils python3-dev swig fakeroot \
	 lzop lz4 aria2 pv toilet figlet crossbuild-essential-arm64 gcc-arm-none-eabi
```

This has been tested on an AMD64/x86_64 system running on [Debian Buster](https://www.debian.org/releases/buster/debian-installer/).

Alternatively, you can run the command `make ccompile` in this directory.

## Instructions

#### Install dependencies

```sh
make ccompile	# Install all dependencies
make ncompile	# Install native dependencies
```

#### Menu interface

```sh
make config     # Create user data file (Foundation Kernel)
make menu       # Open menu interface
make dialogrc   # Set builder theme (optional)
```

#### Config Menu

```sh
Linux kernel
Branch:         # Supported: 5.4.y and above
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile

Raspberry Pi 400 is not currently supported by u-boot.
U-Boot:		# 1 to enable | 0 for foundation boot
Version:	# Supported: v2020.10, v2020.07 and v2020.04

Distribution
Release:	# Supported: bullseye (do not change)
Debian:		# 1 (do not change)

Wireless
rtl88XXau:      # 1 to add Realtek 8812AU/14AU/21AU wireless support
rtl88XXbu:      # 1 to add Realtek 88X2BU wireless support
rtl88XXcu:      # 1 to add Realtek 8811CU/21CU wireless support
```
#### User defconfig

```sh
nano userdata.txt
# place config in defconfig directory
custom_defconfig=1
MYCONFIG="nameofyour_defconfig"
```

#### User patches

```sh
Patches "-p1" placed in patches/userpatches are applied during compilation.
```

## Command list

#### Raspberry Pi 4B

```sh
# AARCH64
make all	# U-boot (if selected) > Kernel > rootfs > image
make uboot
make kernel
make rootfs
make image
```
#### Miscellaneous

```sh
make cleanup    # Clean up image errors
make purge      # Remove source directory
make purge-all  # Remove source and output directory
make commands   # List legacy commands
```

## Usage

#### /boot/rename_to_credentials.txt
```sh
Rename file to credentials.txt and input your wifi information.

NAME=" "			# Name of the connection
SSID=" "			# Service set identifier
PASSKEY=" "			# Wifi password
COUNTRYCODE=" "			# Your country code

MANUAL=n			# Set to y to enable a static ip
IPADDR=" "			# Static ip address
GATEWAY=" "			# Your Gateway
DNS=""				# Your preferred dns

CHANGE=n			# Set to y to enable
HOSTNAME="raspberrypi"		# Set the system's host name
BRANDING="Raspberry Pi"		# Set ASCII text banner
```

#### Using deb-eeprom ([usb_storage.quirks](https://github.com/pyavitz/rpi-img-builder/issues/17))

```sh
Raspberry Pi 4B EEPROM Helper Script
Usage: deb-eeprom -opt

   -v       Edit version variable
   -U       Upgrade eeprom package
   -w       Setup and install usb boot
   -u       Update script

Note:
Upon install please run 'deb-eeprom -u' before using this script.
```

#### CPU frequency scaling
```sh
Usage: governor -opt

   -c       Conservative
   -o       Ondemand
   -p       Performance

   -r       Run
   -u       Update

A service runs 'governor -r' during boot.
```

---

### Support

Should you come across any bugs, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Freenode; [`#debianarm-port`](irc://irc.freenode.net/#debianarm-port)
