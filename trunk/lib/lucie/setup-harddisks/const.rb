#
# $Id: setup-harddisk.rb 595 2005-04-28 07:37:05Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 595 $
# License::  GPL2

module Lucie
  module SetupHarddisks
    MEGABYTE = 1024 * 1024
    GIGABYTE = 1024 * MEGABYTE
    SECTOR_SIZE = 512

    # Partition ID
    PARTITION_ID_EMPTY          = 0x0
    PARTITION_ID_FAT16S         = 0x4    # FAT16 (< 32MB)
    PARTITION_ID_EXTENDED       = 0x5
    PARTITION_ID_FAT16          = 0x6    # FAT16 (>=32MB)
    PARTITION_ID_FAT32          = 0xb
    PARTITION_ID_LINUX_SWAP     = 0x82
    PARTITION_ID_LINUX_NATIVE   = 0x83
    PARTITION_ID_LINUX_EXTENDED = 0x85
    
    START_NUMBER_OF_LOGICAL_PARTITION = 5
    
    SFDISK_PARTITION_FILE_PREFIX = "sfdisk_table"
    RESULT_FILE = "disk_var.sh"
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: