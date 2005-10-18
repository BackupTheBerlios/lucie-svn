#
# $Id: setup-harddisk.rb 595 2005-04-28 07:37:05Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 595 $
# License::  GPL2

require 'lucie/setup-harddisks/filesystem'

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
        # TODO: ���S���̂��߂Ɏ������Ă��ǂ�
        true
      end

      private
      def check_mount_options(op)
        # TODO: ���S���̂��߂Ɏ������Ă��ǂ�
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