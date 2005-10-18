# = setup-hardisks ƒTƒ“ƒvƒ‹İ’è
#
# $Id: resource.rb 491 2005-03-31 16:10:25Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $Revision: 491 $
# License::  GPL2
#
require 'lucie/setup-harddisks/config'

partition "root" do |part|
  part.slice = "/dev/hda1"
  part.kind = "primary"
  part.fs = "ext2"
  part.mount_point = "/"
  part.size = (96...128)
  part.bootable = true
  part.mount_option << "defaults" << "errors=remount-ro"
end

partition "swap" do |part|
  part.slice = "hda2"
  part.kind = "primary"
  part.fs = "swap"
  part.mount_point = "swap"
  part.size = (400...500)
end

partition "var" do |part|
  part.slice = "hda5"
  part.kind = "logical"
  part.fs = "reiserfs"
  part.mount_point = "/var"
  part.size = 196
  part.preserve = true
end

partition "usr" do |part|
  part.slice = "hda6"
  part.kind = "logical"
  part.fs = "reiserfs"
  part.mount_point = "/usr"
  part.size = (2048...9999999)
end

partition "home" do |part|
  part.slice = "sdb1"
  part.mount_point = "/home"
  part.preserve = true
end
