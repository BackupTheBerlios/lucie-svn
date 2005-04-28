#
# $Id: lucie-setup.rb 511 2005-04-05 04:59:48Z takamiya $
#
# setup_harddisks -- create partitions and filesystems on harddisk
#
# This program first read the configfiles, partitions and formats the
# harddisks, produces fstab.  It uses sfdisk, mke2fs, mkswap
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 511 $
# License::  GPL2

require 'English'
require 'lucie/setup_harddisk'

if __FILE__ == $PROGRAM_NAME
  Lucie::SeupHarddisk.instance.main
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
