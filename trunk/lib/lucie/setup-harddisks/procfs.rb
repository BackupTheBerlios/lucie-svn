#
# $Id$
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/setup-harddisks/filesystem'

module Lucie
  module SetupHarddisks
    class Proc < Filesystem
      def initialize()
        @fs_type = "proc"
        @format_program = ""
        @mount_program = ""
        @fsck_enabled = false
        @format_options = []
        @mount_options = []
        @fstab_options = ["defaults"]
      end
      
      public
      def format(device) end
      def mount(device, mount_point) end
      def mount_with_label(label, mount_point)end
      
    end
  end
end
### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: