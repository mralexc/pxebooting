#!/bin/bash
SYSTEM_USER_NAME=$(id -un)
PROCEED=''

if [[ "$SYSTEM_USER_NAME" == 'root' ]]; then
    echo "This will configure tftpd-hpa for pxe booting"
    read -p "Do you want to proceed? " PROCEED
else
    echo "This script has to be run as root"
    exit 1
fi

if [[ "$PROCEED" == 'y' || "$PROCEED" == 'Y' ]]; then
    apt update
    apt install pxelinux syslinux tftpd-hpa
    mkdir -p /tftp/pxelinux.cfg
    touch /tftp/pxelinux.cfg/default
    cp -av /usr/lib/syslinux/modules/bios/{vesamenu.c32,ldlinux.c32,libcom32.c32,libutil.c32} /tftp/
    cp -v /usr/lib/PXELINUX/pxelinux.0 /tftp/
    chown -R tftp:tftp /tftp
    systemctl enable tftpd-hpa
    systemctl start tftpd-hpa
else
    echo "Exiting Program, no changes made"
    exit 1
fi