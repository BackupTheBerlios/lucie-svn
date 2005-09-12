#!/bin/sh

SOURCE="/etc/lucie/install"
TARGET="/var/cache/apt/archives"
LOCAL="/tmp/target"
CONDOR_PKG="condor_6.7.10-1_i386.deb"

#cp /etc/lucie/install/condor_6.7.10-1_i386.deb /tmp/target/var/cache/apt/archives/
cp $SOURCE/$CONDOR_PKG $LOCAL/$TARGET 
chroot $LOCAL dpkg -i $TARGET/$CONDOR_PKG 
