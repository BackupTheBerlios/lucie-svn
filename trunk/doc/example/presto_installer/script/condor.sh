#!/bin/sh

##condorのパッケージをコピーし、インストールするスクリプト##
##script以下に実行権限付で置くことによりインストール中に実行される##

SOURCE="/etc/lucie/install"
LOCALDIR="/var/cache/apt/archives"
CONDOR_PKG="condor_6.7.10-1_i386.deb"

cp $SOURCE/$CONDOR_PKG $target/$LOCALDIR
chroot $target dpkg -i $LOCALDIR/$CONDOR_PKG
