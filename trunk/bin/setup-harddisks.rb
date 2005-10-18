#
# $Id: lucie-setup.rb 511 2005-04-05 04:59:48Z takamiya $
#
# setup-harddisks -- create partitions and filesystems on harddisk
#
# This program first read the configfiles, partitions and formats the
# harddisks, produces fstab.  It uses sfdisk, mke2fs, mkswap
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 511 $
# License::  GPL2
#
# ドキュメントは http://lucie-dev.titech.hpcc.jp:2500/lucie/show/HomePage を
# 参照のこと
#
# Depends: sfdisk, blkid, mke2fs, mkswap, mkfs.reiserfs, mkfs.xfs, swapon, dd, etc.

require 'English'
require 'lucie/setup-harddisks/setup-harddisks'

if __FILE__ == $PROGRAM_NAME
  Lucie::SetupHarddisks::SetupHarddisks.instance.main
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
