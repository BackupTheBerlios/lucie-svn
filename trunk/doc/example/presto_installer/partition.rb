#
# setup-hardisks ƒTƒ“ƒvƒ‹İ’è for presto_installer
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
  part.fs = "ext2"
  part.mount_point = "/"
  part.size = (70..200)
  part.bootable = true
  part.fstab_option << "errors=remount-ro"
  part.dump_enabled = true
end

partition "swap" do |part|
  part.slice = "hda"
  part.kind = "logical"
  part.fs = "swap"
  part.mount_point = "none"
  part.size = (40..500)
end

partition "var" do |part|
  part.slice = "hda"
  part.kind = "logical"
  part.fs = "ext3"
  part.format_option << "-m 5"
  part.mount_point = "/var"
  part.size = (90..1000)
end

partition "tmp" do |part|
  part.slice = "hda"
  part.kind = "logical"
  part.fs = "ext3"
  part.format_option << "-m 0"
  part.mount_point = "/tmp"
  part.size = (50..1000)
end

partition "usr" do |part|
  part.slice = "hda"
  part.kind = "logical"
  part.fs = "ext3"
  part.mount_point = "/usr"
  part.size = (200..4000)
end

partition "home" do |part|
  part.slice = "hda"
  part.kind = "logical"
  part.fs = "ext3"
  part.format_option << "-m 1"
  part.mount_point = "/home"
  part.size = (50..4000)
  part.fstab_option << "nosuid"
end

partition "scratch" do |part|
  part.slice = "hda10"
  part.kind = "logical"
  part.fs = "ext3"
  part.format_option << "-m 0 -i 50000"
  part.mount_point = "/scratch"
  part.size = (50..4000)
  part.fstab_option << "nosuid"
end

#partition "scratch" do |part|
#  part.slice = "hda10"
#  part.mount_point = "/scratch"
#  part.preserve = true
#  part.fstab_option << "nosuid"
#end
