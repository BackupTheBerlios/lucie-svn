#
# $Id: setup-harddisk.rb 595 2005-04-28 07:37:05Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 595 $
# License::  GPL2

require 'lucie/config/resource'
require 'lucie/setup-harddisks/old-partition'

module Lucie
  module SetupHarddisks
    class Disk < Lucie::Config::Resource
      # 登録されている Disk のリスト
      @@list = {}
      
      # アトリビュート名のリスト: [:name, :version, ...]
      @@required_attributes = []
      
      # _すべての_ アトリビュート名とデフォルト値のリスト: [[:name, nil], [:version, '0.0.1'], ...]
      @@attributes = [[:bootable_device, false]]
      
      # アトリビュート名からデフォルト値へのマッピング
      @@default_value = {}
      
      # ------------------------- REQUIRED attributes.
      
      required_attribute :name            # device name
      required_attribute :disk_unit
      required_attribute :disk_size
      required_attribute :bootable_device
      required_attribute :boot_partition
      required_attribute :sector_alignment

      attr_reader :partitions
      attr_reader :old_partitions
      attr_reader :number_of_primary_partitions
      attr_reader :number_of_logical_partitions
      
      # ------------------------- Public class methods.

      private
      def self.list_disks(res = nil)    # an arg is intended for test
        # e.g. ["sda", "sdb"]
        if res == nil
          result = `sfdisk -s`
        else
          result = res
        end
        return result.scan(/^\/dev\/(\w+)/).flatten
      end

      BLKID_PARTITION_ATTRIB_REGEXP = /\A\/dev\/(\w+)(\d+?):.*TYPE="(\w+)".*$/i
      
      public
      def self.save_old_partition_attrib(res = nil)    # an arg is indended for test
        if res == nil
          result = `blkid`
        else
          result = res
        end
        result.each do |line|
          if BLKID_PARTITION_ATTRIB_REGEXP =~ line
            disk=$1
            slice="#{disk}#{$2}"
            fs=$3
            @@list[disk].old_partitions[slice].fs = fs
          end
        end
      end

      public
      def self.assign_partition(part_list)
        # set_partition_positions などのため順序が重要
        parts = part_list.sort_by{|key, part| part.slice}
        parts.each do |key, part|
          disk = part.slice.gsub(/\d*\z/, '')
          raise StandardError, "Could not read device: /dev/#{disk}" unless @@list.has_key?(disk)
          if part.bootable
            if @@list[disk].bootable_device && @@list[disk].boot_partition != part
              raise StandardError, "Only one partition can be bootable at a time."
            else
              @@list[disk].bootable_device = true
              @@list[disk].boot_partition = part
            end
          end
          @@list[disk].partitions << part
        end
      end

      public
      def self.check_settings
        # XXX: 関数の呼び出し順に依存あり
        check_preserve_partition
        check_swap_partition
        check_number_of_bootable_devices
        check_number_of_primary_partitions
        check_partition_order
        calc_requested_partition_size
      end

      public
      def self.write_fstab
        fstab = <<-EOF
# /etc/fstab: static file system information.
#
#<file sys>  <mount point>     <type>   <options>   <dump>   <pass>
        EOF
        @@list.each do |key, disk|
          fstab += disk.write_fstab
        end
        
        if $commandline_options.no_test
          out_file = "#{$commandline_options.log_dir}/fstab"
          begin
            puts fstab if $commandline_options.verbose
            File.open(out_file, "w") do |file| file.puts fstab end
          rescue => ex
            raise
          end
        else
          puts fstab
        end
      end
      
      public
      def self.write_lucie_variables
        out_file = "#{$commandline_options.log_dir}/#{RESULT_FILE}"
        puts "Write Lucie variables to file #{out_file}" if $commandline_options.verbose
        swaps = []
        boot_dev = root_part = boot_part = nil
        @@list.each do |key, disk|
          disk.partitions.each do |part|
            swaps << "/dev/#{part.slice}" if part.fs.instance_of?(Swap)
            root_part = part.slice if part.mount_point == "/"
          end
          if disk.bootable_device
            boot_dev = disk.name 
            boot_part = disk.boot_partition.slice
          end
        end

        result = <<-EOF
BOOT_DEVICE=/dev/#{boot_dev}
ROOT_PARTITION=/dev/#{root_part}
BOOT_PARTITION=/dev/#{boot_part}
SWAPLIST=#{swaps}
        EOF
        
        if $commandline_options.no_test
          begin
            puts result if $commandline_options.verbose
            File.open(out_file, "w") do |file| file.puts result end
          rescue => ex
            raise
          end
        else
          puts result
        end
      end

      # ------------------------- Special accessor behaviours (overwriting default).

      overwrite_accessor :name= do |_name|
        unless (_name.nil?) || ( /\A[\w\-_\/]+\z/ =~ _name)
          raise InvalidAttributeException, "Invalid attribute for name: #{_name}"
        end
        @name = _name.gsub(/^\/dev\//, '').downcase if !_name.nil?
      end


      # ------------------------- Constructor

      public
      def initialize( dev, &block )
        set_default_values
        ENV['LC_ALL']='C'
        @name = dev
        @partitions = []
        @old_partitions = {}
        yield self if block_given?
        register
      end
      
      # ------------------------- Public instance methods

      SFDISK_CHS_REGEXP = /\A\/dev\/(.+?):\s+(\d+)\s+cylinders,\s+(\d+)\s+heads,\s+(\d+)\s+sectors/i
      
      public
      def probe_disk_unit(res = nil)    # an arg is intended for test
        if res == nil
          result = `sfdisk -g -q "/dev/#{@name}"`
        else
          result = res
        end
        if SFDISK_CHS_REGEXP =~ result
          @disk_unit = $3.to_i * $4.to_i;  # heads * sectors = cylinder size in sectors
          @disk_size = $2.to_i;       # cylinders
          ($commandline_options.dos_alignment == true) ? (@sector_alignment = $4.to_i) : (@sector_alignment = 1)            
        end
      end
      
      SFDISK_PARTITION_TABLE_REGEXP = /\A\/dev\/(.+?)\s*:\s+start=\s*(\d+),\s+size=\s*(\d+),\s+Id=\s*([a-z0-9]+)\b(.*)$/i
      
      public
      def save_old_partition(res = nil)    # an arg is intended for test
        if res == nil
          result = `sfdisk -d -q "/dev/#{@name}" 2> /dev/null`
        else
          result = res
        end
        result.each do |line|
          if SFDISK_PARTITION_TABLE_REGEXP =~ line
            slice = $1
            unless @old_partitions.has_key?(slice)
              @old_partitions[slice] = OldPartition.new
            end
            @old_partitions[slice].start_sector = $2.to_i
            @old_partitions[slice].end_sector = $2.to_i + $3.to_i - 1
            @old_partitions[slice].start_unit = @old_partitions[slice].start_sector / @disk_unit
            @old_partitions[slice].end_unit = @old_partitions[slice].end_sector / @disk_unit
            
            tmp = $2.to_i / @sector_alignment.to_f
            @old_partitions[slice].not_aligned = true if tmp != tmp.to_i
            tmp = $3.to_i / @sector_alignment.to_f
            @old_partitions[slice].not_aligned = true if tmp != tmp.to_i
            
            @old_partitions[slice].id = $4.to_i(16)
            
            rest = $5
            @old_partitions[slice].bootable = (/bootable/ =~ rest) ? true : false;
          end
        end
      end
      
      public
      def check_preserve_partition
        @partitions.each do |part|
          if part.preserve
            slice = part.slice
            if @old_partitions.has_key?(slice)
              old_part = @old_partitions[slice]
            else
              raise StandardError, "Cannot preserve partition /dev/#{slice}. Partition not found."
            end
            
            if old_part.not_aligned
              raise StandardError, "Unable to preserve partition /dev/#{slice}. Partition is not DOS aligned."
            end
            
            if old_part.id == PARTITION_ID_EXTENDED ||
                 old_part.id == PARTITION_ID_LINUX_EXTENDED
              raise StandardError, "Extended partitions can not be preserved. /dev/#{slice}"
            end
            
            part.copy_from_old(old_part)
            
            unless @last_preserve_partition.nil?
              if old_part.start_unit < @old_partitions[@last_preserve_partition].start_unit
                raise StandardError, "Misordered partitions: cannot preserve partitions /dev/#{@last_preserve_partition} and /dev/#{slice} in this order because of their positions on disk."
              end
            end
            @last_preserve_partition = slice

            if part.size < 1
              raise StandardError, "Unable to preserve partitions of size 0."
            end
          else
            # If not preserve we must know the filesystemtype
            # TODO: Implement here
          end
        end
      end

      public
      def check_swap_partition
        @partitions.each do |part|
          if part.fs.instance_of?(Swap) && part.mount_point != "none"
            part.mount_point = "none"
            puts "Mountpoints of swap partition should be 'none'"
          end
        end
      end
      
      public
      def check_number_of_primary_partitions
        @number_of_primary_partitions = 0
        @number_of_logical_partitions = 0
        @partitions.each do |part|
          case part.kind
            when "primary"
              @number_of_primary_partitions += 1
            when "logical"
              @number_of_logical_partitions += 1
            when nil
              # may be preserve partition
            else
              # should not reach here.
              raise StandardError, "Invalid attribute for kind: #{part.kind}"
          end
        end
        if (@number_of_primary_partitions > 3 && @number_of_logical_partitions > 0) ||
             @number_of_primary_partitions > 4
          raise StandardError, "Too much primary partitions (max 4) for /dev/#{@name}. All logicals together need one primary too."
        end
      end
      
      public
      def check_partition_order
        no_more_logicals = false
        once_logical = false
        @partitions.each do |each|
          case each.kind
            when "primary"
              if once_logical
                no_more_logicals = true
              end
            when "logical"
              if no_more_logicals
                raise StandardError, "The logical partitions must be together."
              end
              if !once_logical
                once_logical = true
              end
          end

          slice_number = each.slice_number
          if slice_number < START_NUMBER_OF_LOGICAL_PARTITION
            if each.kind.nil?
              each.kind = "primary"
            end
          else
            if each.kind.nil?
              each.kind = "logical"
            elsif each.kind == "primary"
              raise StandardError, "Partition after number #{START_NUMBER_OF_LOGICAL_PARTITION} must be a logical partition."
            end
          end
        end
      end
      

      public
      def calc_requested_partition_size
        @partitions.each do |part|
          if part.size.is_a?(Range)
            part.min_size = ((part.size.first * MEGABYTE - 1) / (@disk_unit * SECTOR_SIZE)) + 1
            part.max_size = ((part.size.last  * MEGABYTE - 1) / (@disk_unit * SECTOR_SIZE)) + 1
            part.max_size = @disk_size if part.max_size > @disk_size
          else
            part.min_size = part.max_size = ((part.size * MEGABYTE - 1) / (@disk_unit * SECTOR_SIZE)) + 1
          end
        end
      end


      public
      def build_partition_table
        set_partition_positions
        # change units to sectors
        @partitions.each do |each|
          unless each.preserve   # preserve partition は check_settings->check_preserve_partition でコピー済み
            each.start_sector = each.start_unit * @disk_unit
            each.end_sector = each.end_unit * @disk_unit - 1
            each.size *= @disk_unit
          end
          # align first partition for mbr
          # TODO: dos alignment の調整は set_parition_positions 内で先にやっておくべきか
          if each.start_sector == 0
            each.start_sector += @sector_alignment
            each.size -= @sector_alignment
          end
        end
        
        # align all logical partitions
        @partitions.each do |each|
          next if each.kind == "primary"
          if each.slice_number == START_NUMBER_OF_LOGICAL_PARTITION
            # First logical partition and start of extended partition
            @start_sector_of_extended = each.start_sector
            @start_sector_of_extended -= @sector_alignment if each.preserve
          end
          unless each.preserve
            each.start_sector += @sector_alignment
            each.size -= @sector_alignment
          end
        end
        
        calculate_extended_partition_size
        print_partition_table if $commandline_options.verbose
      end
      
      # set position for every partition
      # TODO: テスト完了後 private 化
      # TODO: disk_unit で計算しているため多少誤差がある
      public
      def set_partition_positions
        unpreserved_group = []
        start_position = end_position = 0
        @partitions.each do |each|
          if each.preserve
            end_position = @old_partitions[each.slice].start_unit - 1
            set_unreserved_group_position(unpreserved_group, start_position, end_position)
            unpreserved_group.clear
            start_position = @old_partitions[each.slice].end_unit + 1
          else
            unpreserved_group << each
          end
        end
        end_position = @disk_size - 1
        set_unreserved_group_position(unpreserved_group, start_position, end_position)
        @partitions.each do |each|
          if each.fs.instance_of?(Fat16) && each.size * @disk_unit * SECTOR_SIZE < 32 * MEGABYTE
            each.id = PARTITION_ID_FAT16S
          end
        end
      end
      
      # set position for a group of unpreserved partitions between start and end
      # TODO: テスト完了後 private 化
      public
      def set_unreserved_group_position(unpreserved_group, start_position, end_position)
        return if unpreserved_group.empty?
        total_size = end_position - start_position + 1
        return if total_size <= 0
        
        min_total = max_min_total = rest = 0
        unpreserved_group.each do |each|
          min_total += each.min_size
          max_min_total += each.max_size - each.min_size
          each.size = each.min_size
        end
        
        # Test if partitions fit
        raise StandardError, "Mountpoints #{unpreserved_group} do not fit." if min_total > total_size
        # Maximize partitions
        rest = total_size - min_total
        rest = max_min_total if rest > max_min_total
        if rest > 0
          unpreserved_group.each do |each|
            each.size += ((each.max_size - each.min_size) * rest) / max_min_total
          end
        end
        # compute rest
        rest = total_size
        unpreserved_group.each do |each|
          rest -= each.size
        end
        # Minimize rest
        unpreserved_group.each do |each|
          if (rest > 0) && (each.size < each.max_size)
            each.size += 1
            rest -= 1
          end
        end
        # Set start for every partition
        unpreserved_group.each do |each|
          each.start_unit = start_position
          each.end_unit = start_position += each.size
        end
      end

      public
      def fdisk
        if @partitions.empty?
          puts "Skipping sfdisk on /dev/#{@name}: there is no partitions" if $commandline_options.verbose
          return
        end
        sfdisk_table = "# partition table of device: /dev/#{@name}\n\n"
        primary_no = 1
        @partitions.each do |part|
          primary_no += 1 if part.kind =~ /primary|extended/
          if part.slice_number == START_NUMBER_OF_LOGICAL_PARTITION &&
              primary_no < START_NUMBER_OF_LOGICAL_PARTITION
            (primary_no..(START_NUMBER_OF_LOGICAL_PARTITION - 1)).each do |each|
              sfdisk_table += build_sfdisk_dump_line(build_slice_name(each), 0, 0, 0) + "\n"
            end
          end
          line = build_sfdisk_dump_line(part.slice, part.start_sector, part.size, part.id.to_s(16))
          line += ", bootable" if part == boot_partition
          sfdisk_table += "#{line}\n"
        end
        sfdisk_input_file = $commandline_options.log_dir + "/#{SFDISK_PARTITION_FILE_PREFIX}." + @name.gsub('/', '_')
        if $commandline_options.no_test
          begin
            File.open(sfdisk_input_file, "w") do |file|
              file.printf sfdisk_table
            end
          rescue => ex
            raise
          end
        else
          printf sfdisk_table
        end
        command = "sfdisk -q -uS /dev/#{@name} < #{sfdisk_input_file}"
        if $commandline_options.no_test
          `#{command}`
        else
          puts command
        end
      end
      
      public
      def format
        @partitions.each do |each|
          each.format
        end
      end
      
      public
      def mount
        # not used
        @partitions.each do |each|
          each.mount
        end
      end
      
      public
      def write_fstab
        fstab = ""
        @partitions.each do |part|
          fstab += part.write_fstab(@boot_partition)
        end
        return fstab
      end

      # ------------------------- Private class methods

      private
      def self.check_preserve_partition
        @@list.each do |key, disk|
          disk.check_preserve_partition
        end
      end
      
      private
      def self.check_swap_partition
        @@list.each do |key, disk|
          disk.check_swap_partition
        end
      end
      
      private
      def self.check_number_of_bootable_devices
        number_of_bootable_device = 0
        @@list.each do |key, disk|
          number_of_bootable_device += 1 if disk.bootable_device
        end
        if number_of_bootable_device == 0
          @@list.each do |key, disk|
            disk.partitions.each do |part|
              if part.mount_point == "/"
                disk.bootable_device = true
                number_of_bootable_device += 1
              end
            end
          end
        end
        raise StandardError, "Only one device must be bootable." if number_of_bootable_device != 1
      end
            
      private
      def self.check_partition_order
        @@list.each do |key, disk|
          disk.check_partition_order
        end
      end
      
      private
      def self.check_number_of_primary_partitions
        @@list.each do |key, disk|
          disk.check_number_of_primary_partitions
        end
      end

      private
      def self.calc_requested_partition_size
        @@list.each do |key, disk|
          disk.calc_requested_partition_size
        end
      end
      
      # ------------------------- Private instance methods
      
      # calculate extended partition size
      private
      def calculate_extended_partition_size
        ext_part = insert_extended_partition
        return if ext_part.nil?

        ext_end = @start_sector_of_extended
        @partitions.each do |part|
          if part.kind == "logical"
            new_end = 
            ext_end = part.end_sector if part.end_sector > ext_end
          end
        end
        ext_part.start_sector = @start_sector_of_extended
        ext_part.end_sector = ext_end
        ext_part.size = ext_part.end_sector - ext_part.start_sector + 1
      end
      
      private
      def insert_extended_partition
        # TODO: logical は5以上チェック！
        return if @partitions.empty?
        idx = 0
        find_logical = false
        @partitions.each do |part|
          if part.kind == "logical"
            find_logical = true
            break
          end
          idx += 1
        end
        return unless find_logical

        if idx == 0
          slice_num = 1
        else
          slice_num = @partitions[idx-1].slice_number + 1
          if slice_num > 4
            # should not reach here
            raise StandardError, "There is no space for extended partition"
          end
        end

        ext_part = partition "#{@name}#{slice_num}_extended" do |part|
          # TODO: size を指定
          part.slice = "#{@name}#{slice_num}"
          part.kind = "extended"
          part.id = PARTITION_ID_EXTENDED
        end
        @partitions.insert(idx, ext_part)
        return ext_part
      end

      private
      def print_partition_table
        @partitions.each do |each|
          if each.mount_point.nil?#
            mp = "none"
          else
            mp = each.mount_point
          end
          puts "/dev/#{each.slice} #{mp} start=#{each.start_sector} size=#{each.size} end=#{each.end_sector} id=0x#{each.id.to_s(16)}"
        end
      end
      
      private
      def build_slice_name(num)
        return "#{@name}#{num}"
      end
      
      private
      def build_sfdisk_dump_line(*param)
        sprintf "/dev/%-5s: start=%10s, size=%10s, Id=%3s", *param
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
