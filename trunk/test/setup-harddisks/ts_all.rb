#!/usr/bin/env ruby
#
# $Id: ts_all.rb 1111 2007-03-02 08:12:44Z takamiya $
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision: 1111 $
# License:: GPL2


$VERBOSE = true


require 'tc_disk.rb'
require 'tc_ext2.rb'
require 'tc_ext3.rb'
require 'tc_fat16.rb'
require 'tc_fat32.rb'
require 'tc_partition.rb'
require 'tc_reiserfs.rb'
require 'tc_setup-harddisks.rb'
require 'tc_swap.rb'
require 'tc_xfs.rb'


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
