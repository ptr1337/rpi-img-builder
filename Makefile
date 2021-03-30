# menu
MENU=./lib/dialog/menu
CONF=./lib/dialog/config
MLCONF=./lib/dialog/ml_config
ADMIN=./lib/dialog/admin_config
DIALOGRC=$(shell cp -f lib/dialogrc ~/.dialogrc)

# rootfs
RFSV8=./scripts/rootfs
ROOTFSV8=sudo ./scripts/rootfs

# kernel
SELECT=./scripts/select
XLINUX=./scripts/linux
LINUX=sudo ./scripts/linux

# stages
DEB=./scripts/debian-stage1
DEBIAN=sudo ./scripts/debian-stage1
DEBSTG2=./scripts/debian-stage2

# choose distribution
CHOOSE=./scripts/choose

# clean
CLN=./scripts/clean
CLEAN=sudo ./scripts/clean

# purge
PURGE=$(shell sudo rm -fdr source)
PURGEALL=$(shell sudo rm -fdr source output)

# help
XHELPER=./scripts/help
HELPER=sudo ./scripts/help
XCHECK=./scripts/check
CHECK=./scripts/check

help:
	@echo
	@echo "\e[1;31m             Raspberry Pi Image Builder\e[0m"
	@echo "\e[1;37m             **************************"
	@echo "\e[1;37mUsage:\e[0m "
	@echo
	@echo "  make ccompile          Install cross dependencies"
	@echo "  make ncompile          Install native dependencies"
	@echo "  make config            Create user data file"
	@echo "  make menu              User menu interface"
	@echo "  make cleanup           Clean up image errors"
	@echo "  make purge             Remove source directory"
	@echo "  make purge-all         Remove source and output directory"
	@echo "  make commands          List more commands"
	@echo
	@echo "For details consult the \e[1;37mREADME.md\e[0m"
	@echo

commands:
	@echo
	@echo "Boards:"
	@echo
	@echo "  bcm2711                 Raspberry Pi 4B"
	@echo "  bcm2710                 Raspberry Pi 2/3/A/B/+"
	@echo
	@echo "bcm2711:"
	@echo " "
	@echo "  make kernel             Builds linux kernel"
	@echo "  make image              Make bootable image"
	@echo "  make all                Kernel > rootfs > image"
	@echo
	@echo "bcm2710:"
	@echo " "
	@echo "  make rpi3-kernel        Builds linux kernel"
	@echo "  make rpi3-image         Make bootable image"
	@echo "  make rpi3-all           Kernel > rootfs > image"
	@echo
	@echo "Root filesystem:"
	@echo
	@echo "  make rootfs		  arm64"
	@echo
	@echo "Miscellaneous:"
	@echo
	@echo "  make dialogrc		  Set builder theme"
	@echo "  make check		  Shows latest revision of selected branch"
	@echo "  make helper		  Reduce the time it takes to create a new image"
	@echo

# aarch64
ccompile:
	# Install all dependencies:
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync make \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig libelf-dev \
	aria2 pv toilet figlet lsb-release xz-utils curl e2fsprogs btrfs-progs \
	distro-info-data crossbuild-essential-arm64 gcc-8 gcc-9 gcc-10 kpartx \
	gcc-8-aarch64-linux-gnu gcc-9-aarch64-linux-gnu gcc-10-aarch64-linux-gnu \
	debian-archive-keyring debian-keyring

ncompile:
	# Install native dependencies:
	sudo apt install build-essential bison bc git dialog patch \
	dosfstools zip unzip qemu debootstrap qemu-user-static rsync \
	kmod cpio flex libssl-dev libncurses5-dev parted fakeroot swig \
	aria2 pv toilet figlet distro-info-data lsb-release xz-utils curl \
	e2fsprogs btrfs-progs kpartx gcc-8 gcc-9 gcc-10 debian-archive-keyring \
	debian-keyring make libelf-dev

# Raspberry Pi 4 | aarch64
kernel:
	# Linux | aarch64
	@ echo bcm2711 > soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}

image:
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

all:
	# RPi4B | aarch64
	# - - - - - - - -
	#
	# Building linux
	@ echo bcm2711 > soc.txt
	@chmod +x ${SELECT}
	@${SELECT}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable image
	@ echo bcm2711 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

# Raspberry Pi 2 / 3 | aarch64
rpi3-kernel:
	# Linux | aarch64
	@ echo bcm2710 > soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}

rpi3-image:
	# Making bootable image
	@ echo bcm2710 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

rpi3-all:
	# RPi2/3 | aarch64
	# - - - - - - - -
	#
	# Building linux
	@ echo bcm2710 > soc.txt
	@chmod +x ${XLINUX}
	@${LINUX}
	# Creating ROOTFS tarball
	@chmod +x ${RFSV8}
	@${ROOTFSV8}
	# Making bootable image
	@ echo bcm2710 > soc.txt
	@chmod +x ${CHOOSE}
	@${CHOOSE}

# rootfs
rootfs:
	# ROOTFS
	@chmod +x ${RFSV8}
	@${ROOTFSV8}

# clean and purge
cleanup:
	# Cleaning up
	@chmod +x ${CLN}
	@${CLEAN}

purge:
	# Removing source directory
	@${PURGE}

purge-all:
	# Removing source and output directory
	@${PURGEALL}

# menu
menu:
	# User menu interface
	@chmod +x ${MENU}
	@${MENU}

config:
	# User config menu
	@chmod go=rx files/scripts/*
	@chmod go=rx files/debian/scripts/*
	@chmod go=r files/misc/*
	@chmod go=r files/debian/rules/*
	@chmod go=r files/users/*
	@chmod go=r files/autopair/*
	@chmod +x ${CONF}
	@${CONF}

# miscellaneous
dialogrc:
	# Builder theme set
	@${DIALOGRC}

check:
	# Check kernel revisions
	@chmod +x ${XCHECK}
	@${CHECK}

# raspberry pi4 select
select:
	# Selecting kernel
	@chmod +x ${SELECT}
	@${SELECT}

# distros
debianos:
	# Debian
	@chmod +x ${DEB}
	@chmod +x ${DEBSTG2}
	@${DEBIAN}

# kernel helper
helper:
	# Helper script
	@chmod +x ${XHELPER}
	@${HELPER} -h

2710:
	# BCM2710
	@chmod +x ${XHELPER}
	@${HELPER} -3

2711:
	# BCM2711
	@chmod +x ${XHELPER}
	@${HELPER} -4
