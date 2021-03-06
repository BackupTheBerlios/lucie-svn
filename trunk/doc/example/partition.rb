#
# setup-hardisks サンプル設定
#
# $Id: resource.rb 491 2005-03-31 16:10:25Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $Revision: 491 $
# License::  GPL2
#
require 'lucie/setup-harddisks/config'

partition "root" do |part|
  part.slice = "/dev/hda"
  part.kind = "primary"
  part.fs = "ext3"
  part.mount_point = "/"
  part.size = (128..256)
  part.bootable = true
  part.fstab_option << "errors=remount-ro"
  part.dump_enabled = true
end

partition "swap" do |part|
  part.slice = "hda"
  part.kind = "primary"
  part.fs = "swap"
  part.mount_point = "none"
  part.size = (256..512)
end

partition "var" do |part|
  part.slice = "hda"
  part.kind = "logical"
  part.fs = "reiserfs"
  part.mount_point = "/var"
  part.size = 256
end

partition "usr" do |part|
  part.slice = "hda"
  part.kind = "logical"
  part.fs = "reiserfs"
  part.mount_point = "/usr"
  part.size = (512..9999999)
end

partition "home" do |part|
  part.slice = "hda7"
  part.kind = "logical"
  part.fs = "reiserfs"
  part.mount_point = "/home"
  part.size = 512
  part.fstab_option << "nosuid"
end

#partition "home" do |part|
#  part.slice = "hda7"
#  part.mount_point = "/home"
#  part.preserve = true
#  part.fstab_option << "nosuid"
#end
