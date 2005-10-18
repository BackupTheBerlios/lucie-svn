#
# $Id: tc_specification.rb 670 2005-06-02 08:26:55Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 670 $
# License::  GPL2

$LOAD_PATH.unshift 'trunk/lib'

require 'lucie/setup-harddisks/command-line-options'
require 'lucie/setup-harddisks/config'
require 'test/unit'

include Lucie::SetupHarddisks

class TC_Partition < Test::Unit::TestCase
  public
  def setup
    $commandline_options = CommandLineOptions.instance
    @part1 = partition "root"  do |part|
      part.slice = "/dev/sda1"
      part.kind = "primary"
      part.fs = "ext3"
      part.mount_point = "/"
      part.size = (128...200)
      part.bootable = true
      part.mount_option << "rw" << "nosuid"
      part.format_option << "-j ext3"
    end
    
    @part2 = partition "swap" do |part|
      part.slice = "/dev/sda2"
      part.kind = "logical"
      part.fs = "swap"
      part.mount_point = "swap"
      part.size = 1024
    end
  end
  
  public
  def teardown
    Partition.clear
  end
  

  # 各属性に値をセットできることをテスト
  public
  def test_setter_methods
    [:name, :kind, :fs, :format_option].each do |each|
      setter_method_test each
    end
  end

  private
  def setter_method_test( attributeNameSymbol )
    begin
      partition attributeNameSymbol.to_s do |part|
        part.send( attributeNameSymbol.to_s + '=', nil )
      end
    rescue
      fail "#{attributeNameSymbol} 属性に値をセットするときにエラーが発生"
    end
  end
  
  public
  def test_set_values
    assert_equal( "root", @part1.name )
    assert_equal( "sda1", @part1.slice )
    assert_equal( "primary", @part1.kind )
    assert_instance_of(Ext3, @part1.fs)
    assert_equal( "/", @part1.mount_point )
    assert_equal( (128...200), @part1.size )
    assert_equal( true, @part1.bootable )
    assert_equal( [ "rw", "nosuid" ], @part1.mount_option )
    assert_equal( [ "-j ext3" ], @part1.format_option )
  end
  
  public
  def test_set_values_with_condition
    disk_size = 120
    @part1.size =
      if disk_size < 100
        20
      elsif disk_size < 200
        80
      else
        120
      end
    assert_equal( 80, @part1.size )
  end
  
  # 各アクセッサのテスト

  public
  def test_set_name
    assert_raises(InvalidAttributeException) {
      @part2.name = "*"
    }
    assert_nothing_raised {
      @part2.name = "home2"
    }
  end
  
  public
  def test_set_slice
    assert_raises(InvalidAttributeException) {
      partition "root2"  do |part|
        part.slice = "/dev/sda1"
      end
    }
  end
  
  public
  def test_set_fs
    assert_raises(InvalidAttributeException) {
      @part2.fs = "fat16"
      @part2.fs = "sapw"
    }
    assert_nothing_raised {
      @part2.fs = "ext2"
      @part2.fs = "ExT3"
      @part2.fs = "ReiserFS"
      @part2.fs = "XFS"
      @part2.fs = "swaP"
    }
  end
  
  public
  def test_set_size
    assert_raises(InvalidAttributeException) {
      @part2.size = "string"
    }
    assert_nothing_raised {
      @part2.size = 10
      @part2.size = 10.10
      @part2.size = (10..100)
    }
  end
  
  public
  def test_set_mount_point
    assert_raises(InvalidAttributeException) {
      @part2.mount_point = "invalid"
    }
    assert_nothing_raised {
      @part2.mount_point = "/usr"
      @part2.mount_point = "/usr/local"
      @part2.mount_point = "SwAP"
      @part2.mount_point = "-"
    }
    assert_raises(InvalidAttributeException) {
      @part2.mount_point = "/"
    }
  end
  
  public
  def test_format
    @part1.fs = "ext3"
    @part1.format_option = "-c"
    @part1.slice = "/dev/hda5"
#     @part1.format
  end
  
  public
  def test_set_preserve
    assert_nothing_raised {
      @part1.preserve = true
      @part1.preserve = false
    }
    assert_raises(InvalidAttributeException) {
      @part1.preserve = "yes"
    }
  end
  
  public
  def test_bootability1
    assert_nothing_raised {
      @part1.bootable = true
      @part1.kind = "primary"
    }
    assert_raises(InvalidAttributeException) {
      @part1.bootable = true
      @part1.kind = "logical"
    }
  end
  
  public
  def test_bootability2
    assert_nothing_raised {
      @part1.kind = "primary"
      @part1.bootable = true
    }
    assert_raises(InvalidAttributeException) {
      @part1.kind = "logical"
      @part1.bootable = true
    }
  end

  # ------------------------- Debug メソッドのテスト.

  public
  def test_to_s
    assert_equal( %{#<Lucie::SetupHarddisks::Partition name=root version=>}, @part1.to_s,
                  "Partition#to_s の返り値が正しくない" )
  end

  public
  def test_inspect
    assert_equal( %{#<Lucie::SetupHarddisks::Partition name=root version=>}, @part1.inspect,
                  "Partition#inspect の返り値が正しくない" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
