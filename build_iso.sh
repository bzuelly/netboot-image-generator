#!/bin/bash

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
ME=`basename "$0"`

MOUNT_ISO_FOLDER="/mnt/iso"
EXTRACT_ISO_FOLDER="/tmp/r8"
NEW_IMAGE_NAME="netboot-RockyV2"
ORIG_ISO_NAME="Rocky-8-5-x86_64-dvd"
DOWNLOAD_ISO="Rocky-8.5-x86_64-boot.iso"
MIRROR=""

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
CLS='\033[0m'

wget $MIRROR$DOWNLOAD_ISO
##mount /tmp/$DOWNLOAD_ISO $MOUNT_ISO_FOLDER

#cp -vf $MOUNT_ISO_FOLDER/.??* $EXTRACT_ISO_FOLDER
##rsync -av --progress $MOUNT_ISO_FOLDER $EXTRACT_ISO_FOLDER

sed -i '/menu default/d' $EXTRACT_ISO_FOLDER/isolinux/isolinux.cfg

sed -i '/label check/i \
label auto \
  menu label ^Auto install EL 8 \
  kernel vmlinuz \
  menu default \
  append initrd=initrd.img inst.ks=http://xweb.xlab.lcl/unattend/ks.cfg \
  # end' $EXTRACT_ISO_FOLDER/isolinux/isolinux.cfg


mkisofs -o $SCRIPT_PATH/images/$NEW_IMAGE_NAME.iso \
        -b isolinux/isolinux.bin \
	-c isolinux/boot.cat \
	-boot-load-size 4 \
	-boot-info-table \
	-no-emul-boot \
  -eltorito-alt-boot    \
  -e images/efiboot.img     \
  -no-emul-boot \
	-R \
	-J \
	-v \
	-V '$ORIG_ISO_NAME' \
	-T $EXTRACT_ISO_FOLDER

umount $MOUNT_ISO_FOLDER
echo -e "${GREEN}Delete $EXTRACT_ISO_FOLDER${CLS}"
##rm -rf $EXTRACT_ISO_FOLDER