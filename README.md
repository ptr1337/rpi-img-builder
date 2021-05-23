**Armhf Branch**
## Image Builder for the Raspberry Pi

## The boards and distributions that are currently supported
* Raspberry Pi 4B | Debian, Devuan and Ubuntu
* Raspberry Pi 2/3/A/B/+ | Debian, Devuan and Ubuntu
* Raspberry Pi 0/W/B/+ | Debian and Devuan
* [Raspberry Pi Hardware](https://www.raspberrypi.org/documentation/hardware/raspberrypi)

## Dependencies

In order to install the required dependencies, run the following command:

```
sudo apt install \
	build-essential bison bc git dialog patch dosfstools zip unzip qemu debootstrap \
	qemu-user-static rsync kmod cpio flex libssl-dev libncurses5-dev parted fakeroot \
	swig aria2 pv toilet figlet distro-info-data lsb-release xz-utils curl e2fsprogs \
	btrfs-progs kpartx crossbuild-essential-armhf crossbuild-essential-armel gcc-8 \
	gcc-8-arm-linux-gnueabi gcc-9-arm-linux-gnueabi gcc-10-arm-linux-gnueabi gcc-9 \
	gcc-8-arm-linux-gnueabihf gcc-9-arm-linux-gnueabihf gcc-10-arm-linux-gnueabihf \
	gcc-10 debian-archive-keyring debian-keyring libelf-dev
```

This has been tested on an AMD64/x86_64 system running on [Ubuntu Focal](https://releases.ubuntu.com/20.04/).

Alternatively, you can run the command `make ccompile` in this directory.

---

## Instructions

#### Install dependencies

```sh
make ccompile	# Install cross dependencies
make ncompile	# Install native dependencies
```

#### Menu interface

```sh
make config     # Create user data file (Foundation Kernel)
make mlconfig   # Create user data file (Mainline Kernel)
make menu       # Open menu interface
make dialogrc   # Set builder theme (optional)
```

#### Config Menu

```sh
Username:       # Your username
Password:       # Your password
Enable root:	# 1 to enable (set root password to `toor`)

Linux kernel
Branch:         # Supported: 5.10.y and above
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile
Caching on:     # 1 to enable ccache

Distribution
Distro:		# Supported: debian, devuan and ubuntu
Release:	# Debian: buster, bullseye, testing, unstable and sid
		# Devuan: beowulf, testing, unstable and ceres
		# Ubuntu: focal and hirsute

Customize (user defconfig)
Defconfig:	# 1 to enable
Name:		# Name of _defconfig (Must be placed in defconfig dir.)
```

#### Mainline Config Menu (RPi4B ONLY)

```sh
Username:       # Your username
Password:       # Your password
Enable root:	# 1 to enable (set root password to `toor`)

Linux kernel
Branch:         # Selected kernel branch
RC:             # 1 for kernel x.y-rc above stable
Menuconfig:     # 1 to run kernel menuconfig
Crosscompile:   # 1 to cross compile | 0 to native compile
Caching on:     # 1 to enable ccache

Distribution
Distro:		# Supported: debian, devuan and ubuntu
Release:	# Debian: buster, bullseye, testing, unstable and sid
		# Devuan: beowulf, testing, unstable and ceres
		# Ubuntu: focal and hirsute

Customize (user defconfig)
Defconfig:	# 1 to enable
Name:		# Name of _defconfig (Must be placed in defconfig dir.)
```
### Furthermore
If interested in building a Raspberry Pi 4B image that uses mainline u-boot and linux
use our other [builder](https://github.com/pyavitz/debian-image-builder).

#### User defconfig

```sh
# config placement: defconfig/$NAME_defconfig
The config menu will append _defconfig to the end of the name
in the userdata.txt file.
```

#### User patches

```sh
Patches "-p1" placed in patches/userpatches are applied during
compilation. This works for both Foundation and Mainline kernels.
```

#### User scripts
```sh
nano userdata.txt
# place scripts in files/userscripts directory
userscripts=0	# 1 to enable
``` 

## Command list

#### Raspberry Pi 4B

```sh
# ARMv7
make all	# kernel > rootfs > image (run at own risk)
make kernel	# Foundation
make mainline	# Mainline
make image
```

#### Raspberry Pi 2/3/A/B/+

```sh
# ARMv7
make rpi3-all	# kernel > rootfs > image (run at own risk)
make rpi3-kernel
make rpi3-image
```

#### Raspberry Pi 0/0W/B/+

```sh
# ARMv6
make rpi-all	# kernel > rootfs > image (run at own risk)
make rpi-kernel
make rpi-image
```

#### Root Filesystems

```sh
make rootfs   # armhf
make rootfsv6 # armel
```

#### Miscellaneous

```sh
make cleanup    # Clean up rootfs and image errors
make purge      # Remove source directory
make purge-all  # Remove source and output directory
make commands   # List more commands
make check      # Shows latest revision of selected branch
```

## Usage

### Debian / Devuan
#### /boot/rename_to_credentials.txt
```sh
Rename file to credentials.txt and input your wifi information.

SSID=" "			# Service set identifier
PASSKEY=" "			# Wifi password
COUNTRYCODE=" "			# Your country code

# set static ip
MANUAL=n			# Set to y to enable a static ip
IPADDR=" "			# Static ip address
NETMASK=" "			# Your Netmask
GATEWAY=" "			# Your Gateway
NAMESERVERS=" "			# Your preferred dns

CHANGE=y			# Set to n to disable
HOSTNAME="raspberrypi"		# Set the system's host name
BRANDING="Raspberry Pi"		# Set ASCII text banner

For headless use: ssh user@ipaddress

Note:
You can also mount the ROOTFS partition and edit the following
files, whilst leaving rename_to_credentials.txt untouched.

/etc/opt/interfaces.manual
/etc/opt/wpa_supplicant.manual
```

### Ubuntu
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

CHANGE=y			# Set to n to disable
HOSTNAME="raspberrypi"		# Set the system's host name
BRANDING="Raspberry Pi"		# Set ASCII text banner

For headless use: ssh user@ipaddress
```

### Scripts
#### Using deb-eeprom ([usb_storage.quirks](https://github.com/pyavitz/rpi-img-builder/issues/17))

```sh
Raspberry Pi 4B EEPROM Helper Script
Usage: deb-eeprom -h

   -U       Upgrade eeprom package
   -w       Transfer to USB	# Supported: EXT4, BTRFS and F2FS
   -u       Update script

Note:
Upon install please run 'deb-eeprom -u' before using this script.
```
#### Simple wifi helper (Debian / Devuan)
```sh
swh -h

   -s       Scan for SSID's
   -u       Bring up interface
   -d       Bring down interface
   -r       Restart interface
   -W       Edit wpa supplicant
   -I       Edit interfaces
```
#### CPU frequency scaling
```sh
Usage: governor -h

   -c       Conservative
   -o       Ondemand
   -p       Performance

   -r       Run
   -u       Update

A service runs 'governor -r' during boot.
```

---

### Support

Should you come across any bugs, feel free to either open an issue on GitHub or talk with us directly by joining our channel on Libera; [`#arm-img-builder`](irc://irc.libera.chat/#arm-img-builder)
