#
# $Id: setup-harddisk.rb 595 2005-04-28 07:37:05Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 595 $
# License::  GPL2

require 'lucie/setup-harddisks/filesystem'

module Lucie
  module SetupHarddisks
    class Fat32 < Filesystem
      MAX_LABEL_LENGTH = 11

      def initialize()
        @fs_type = "vfat"
        @format_program = "mkfs.msdos"
        @mount_program = "mount -t vfat"
        @fsck_enabled = false
        @format_options = ["-F 32"]
        @mount_options = []
        @fstab_options = ["defaults"]   # TODO: 要検証
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
        if label.length > MAX_LABEL_LENGTH
          raise StandardError, "Label ('#{label}') length can be at most #{MAX_LABEL_LENGTH} characters."
        else
          return " -n #{label}"
        end
      end
    end
  end
end
### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: