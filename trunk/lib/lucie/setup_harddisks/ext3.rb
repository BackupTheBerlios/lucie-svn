#
# $Id: ext3.rb 957 2005-10-19 07:15:53Z sakae $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 957 $
# License::  GPL2

require 'lucie/setup_harddisks/filesystem'

module Lucie
  module SetupHarddisks
    class Ext3 < Filesystem
      def initialize()
        @fs_type = "ext3"
        @format_program = "mke2fs"
        @mount_program = "mount -t ext3"
        @fsck_enabled = true
        @format_options = ["-j"]
        @mount_options = []
        @fstab_options = ["defaults"]
        super
      end
      
      private
      def check_format_options(op)
        # TODO: 堅牢性のために実装しても良い
        true
      end

      private
      def check_mount_options(op)
        # TODO: 堅牢性のために実装しても良い
        true
      end

      private
      def gen_label_option(label)
        return " -L #{label}"
      end
    end
  end
end
### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: