#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lmp/read-config'
require 'test/unit'

class TC_ReadConfig < Test::Unit::TestCase
  public
  def setup
    @reader = LMP::ReadConfig.new
  end

  public
  def test_read_config
    @reader.read( 'test/lmp/packages.test' )
    read_config_test
  end

  public
  def test_read_config_with_remove_directive
    @reader.read( 'test/lmp/packages.test2' )
    read_config_test
  end

  private
  def read_config_test
    packages = @reader.packages
    assert_kind_of( Hash, packages, 'packages メソッドの返り値の型が Hash じゃない' )
    assert_equal( ['initrd-tools', 'lilo'], packages[:install], 'インストールするパッケージリストが正しくない' )
    assert_equal( ['grub'], packages[:remove], 'アンインストールするパッケージリストが正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
