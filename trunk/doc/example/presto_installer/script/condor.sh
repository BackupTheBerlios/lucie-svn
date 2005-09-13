#!/bin/sh

##condor$B$N%Q%C%1!<%8$r%3%T!<$7!"%$%s%9%H!<%k$9$k%9%/%j%W%H(B##
##script$B0J2<$K<B9T8"8BIU$GCV$/$3$H$K$h$j%$%s%9%H!<%kCf$K<B9T$5$l$k(B##

SOURCE="/etc/lucie/install"
LOCALDIR="/var/cache/apt/archives"
CONDOR_PKG="condor_6.7.10-1_i386.deb"

cp $SOURCE/$CONDOR_PKG $target/$LOCALDIR
chroot $target dpkg -i $LOCALDIR/$CONDOR_PKG
