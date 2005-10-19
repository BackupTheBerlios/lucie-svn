#
# $Id$
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift 'trunk/lib'

require 'lucie/setup-harddisks/config'
require 'lucie/setup-harddisks/disk'
require 'lucie/setup-harddisks/command-line-options'
require 'test/unit'

include Lucie::SetupHarddisks

class TC_Disk < Test::Unit::TestCase
  public
  def setup
    $commandline_options = CommandLineOptions.instance
    disks = ["sda", "sdb"]
    @disk_info = Array.new
    disks.each do |each| @disk_info << Disk.new(each) end
  
    @part1 = partition "root" do |part|
      part.slice = "/dev/sda1"
      part.kind = "primary"
      part.fs = "ext3"
      part.mount_point = "/"
      part.size = (96...128)
      part.bootable = true
      part.format_option << "-v"
      part.fstab_option << "defaults" << "errors=remount-ro"
      part.dump_enabled = true
    end
    
    @part2 = partition "swap" do |part|
      part.slice = "sda2"
      part.kind = "primary"
      part.fs = "swap"
      part.mount_point = "swap"
      part.size = (400...500)
    end
    
    @part3 = partition "var" do |part|
      part.slice = "sda5"
      part.kind = "logical"
      part.fs = "reiserfs"
      part.mount_point = "/var"
      part.size = 196
      part.preserve = true
    end
    
    @part6 = partition "cluster" do |part|
      part.slice = "sda7"
      part.kind = "logical"
      part.fs = "xfs"
      part.mount_point = "/var/cluster"
      part.size = (2048...9999999)
    end
    
    @part4 = partition "usr" do |part|
      part.slice = "sda6"
      part.kind = "logical"
      part.fs = "fat32"
      part.mount_point = "/usr"
      part.size = (2048...9999999)
    end
    
    @part5 = partition "home" do |part|
      part.slice = "sdb1"
      part.mount_point = "/home"
      part.preserve = true
    end
  end
  
  public
  def teardown
    Disk.clear
    Partition.clear
  end
  
  public
  def test_list_disks
    disks = setup_dummy_disks
    assert_equal(["sda", "sdb"], disks)
  end
  
  private
  def setup_dummy_disks
    res = <<-EOF
/dev/sda:  20964825
/dev/sdb:   4192965
total: 25157790 blocks
    EOF
    return Disk.list_disks(res)
  end

  public
  def test_probe_disk_unit
    assert_not_equal(16065, @disk_info[0].disk_unit)
    assert_not_equal(2610, @disk_info[0].disk_size)
    assert_not_equal(1, @disk_info[0].sector_alignment)
    assert_not_equal(16065, @disk_info[1].disk_unit)
    assert_not_equal(522, @disk_info[1].disk_size)
    assert_not_equal(1, @disk_info[1].sector_alignment)

    setup_dummy_disk_unit

    assert_equal(16065, @disk_info[0].disk_unit)
    assert_equal(2610, @disk_info[0].disk_size)
    assert_equal(63, @disk_info[0].sector_alignment)
    assert_equal(16065, @disk_info[1].disk_unit)
    assert_equal(522, @disk_info[1].disk_size)
    assert_equal(63, @disk_info[1].sector_alignment)
  end
  
  private
  def setup_dummy_disk_unit
    res = [ "/dev/sda: 2610 cylinders, 255 heads, 63 sectors/track",
            "/dev/sdb: 522 cylinders, 255 heads, 63 sectors/track" ]
    res.each_index do |each|
      @disk_info[each].probe_disk_unit(res[each])
    end
  end
  
  public
  def test_save_old_partition
    setup_dummy_disk_unit

    assert_nil(@disk_info[0].old_partitions["sda1"])

    setup_dummy_old_partition

    assert_equal(63, @disk_info[0].old_partitions["sda1"].start_sector)
    assert_equal(257039, @disk_info[0].old_partitions["sda1"].end_sector)
    assert_equal(0, @disk_info[0].old_partitions["sda1"].start_unit)
    assert_equal(15, @disk_info[0].old_partitions["sda1"].end_unit)
    assert_equal(0x83, @disk_info[0].old_partitions["sda1"].id)
    assert_equal(false, @disk_info[0].old_partitions["sda1"].not_aligned)
    assert_equal(true, @disk_info[0].old_partitions["sda1"].bootable)
  end
  
  private
  def setup_dummy_old_partition
    res = <<-EOF
# partition table of /dev/sda
unit: sectors

/dev/sda1 : start=       63, size=   256977, Id=83, bootable
/dev/sda2 : start=   257040, size=   996030, Id=82
/dev/sda3 : start=  1253070, size= 40676580, Id= 5
/dev/sda4 : start=        0, size=        0, Id= 0
/dev/sda5 : start=  1253133, size=  4000122, Id=83
/dev/sda6 : start=  5253318, size= 36676332, Id=83
    EOF
    @disk_info[0].save_old_partition(res)
    
    res = <<-EOF
# partition table of /dev/sdb
unit: sectors

/dev/sdb1 : start=       63, size=  8385867, Id=83
/dev/sdb2 : start=        0, size=        0, Id= 0
/dev/sdb3 : start=        0, size=        0, Id= 0
/dev/sdb4 : start=        0, size=        0, Id= 0
    EOF
    @disk_info[1].save_old_partition(res)
  end
  
  public
  def test_save_old_partition_attributes
    setup_dummy_disk_unit
    setup_dummy_old_partition
    setup_dummy_partition_attrib
  end
  
  public
  def setup_dummy_partition_attrib
    res =<<-EOF
/dev/sda1: UUID="692edd20-504b-4458-82fa-078fab6f91cc" TYPE="ext2" 
/dev/sda2: TYPE="swap" 
/dev/sda5: TYPE="reiserfs" 
/dev/sda6: TYPE="reiserfs" 
/dev/sdb1: TYPE="reiserfs"
    EOF
    Disk.save_old_partition_attrib(res)
  end
  
  public
  def test_assign_partition
    Disk.assign_partition(Partition.list)
    @disk_info.each do |disk|
      disk.partitions.each do |part|
        assert_instance_of(Partition, part)
      end
    end
  end
  
  public
  def test_assing_partition2
    assert_raises(StandardError) {
      @part2.bootable = true
      Disk.assign_partition(Partition.list)
    }
    assert_nothing_raised(StandardError) {
      @part2.bootable = false
      Disk.assign_partition(Partition.list)
    }
  end
  
  public
  def test_check_settings
    setup_dummy_disk_unit
    setup_dummy_old_partition
    setup_dummy_partition_attrib
    assert_nothing_raised(StandardError) {
      Disk.assign_partition(Partition.list)
      Disk.check_settings
    }
  end
  
  public
  def test_check_settings2
    assert_raises(StandardError) {
      @part2.bootable = true
      Disk.assign_partition(Partition.list)
      Disk.check_settings
    }
  end
  
  public
  def test_check_number_of_primary_partitions
    partition "tmp0" do |part|
      part.slice = "/dev/sdb2"
      part.kind = "primary"
    end
    partition "tmp1" do |part|
      part.slice = "/dev/sdb3"
      part.kind = "primary"
    end
    partition "tmp2" do |part|
      part.slice = "/dev/sdb4"
      part.kind = "primary"
    end
    partition "tmp3" do |part|
      part.slice = "/dev/sdb5"
      part.kind = "primary"
    end
    partition "tmp4" do |part|
      part.slice = "/dev/sdb6"
      part.kind = "primary"
    end
    Disk.assign_partition(Partition.list)
    assert_raises(StandardError) {
      Disk.check_number_of_primary_partitions
    }
  end

  public
  def test_check_number_of_primary_partitions2
    partition "tmp0" do |part|
      part.slice = "/dev/sdb2"
      part.kind = "primary"
    end
    partition "tmp1" do |part|
      part.slice = "/dev/sdb3"
      part.kind = "primary"
    end
    Disk.assign_partition(Partition.list)
    assert_nothing_raised(StandardError) {
      Disk.check_number_of_primary_partitions
    }
  end
  
  public
  def test_check_partition_kind
    partition "tmp0" do |part|
      part.slice = "/dev/sdb2"
      part.kind = "logical"
    end
    partition "tmp1" do |part|
      part.slice = "/dev/sdb3"
      part.kind = "logical"
    end
    partition "tmp2" do |part|
      part.slice = "/dev/sdb4"
      part.kind = "logical"
    end
    partition "tmp3" do |part|
      part.slice = "/dev/sdb5"
      part.kind = "primary"
    end
    partition "tmp4" do |part|
      part.slice = "/dev/sdb6"
      part.kind = "primary"
    end
    Disk.assign_partition(Partition.list)
    assert_raises(StandardError) {
      @disk_info.each do |each|
        each.check_number_of_primary_partitions
        each.check_partition_order
      end
    }
  end
  
  public
  def test_all
    setup_dummy_disk_unit
    setup_dummy_old_partition
    setup_dummy_partition_attrib
    Disk.assign_partition(Partition.list)
    Disk.check_settings
    assert_nothing_raised(StandardError) {
       @disk_info.each do |disk|
         disk.build_partition_table
         disk.fdisk
         disk.format
         disk.mount
       end
       Disk.write_fstab
       Disk.write_lucie_variables
    }
  end
  
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
