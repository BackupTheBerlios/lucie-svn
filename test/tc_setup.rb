#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/lucie-setup'
require 'test/unit'

class TC_Setup < Test::Unit::TestCase
  # LUCIE_VERSION 定数をテスト
  public
  def test_LUCIE_VERSION
    assert_match( /\A\d+\.\d+\.\d+\Z/, Lucie::Setup::LUCIE_VERSION,
     "LUCIE_VERSION 定数のフォーマットがおかしい" )
  end
  
  # VERSION_STRING 定数をテスト
  public
  def test_VERSION_STRING
    assert_match( /\Alucie-setup\s+\d+\.\d+\.\d+\s+\(\d\d\d\d-\d\d-\d\d\)\Z/, Lucie::Setup::VERSION_STRING, 
    "VERSION_STRING 定数のフォーマットがおかしい" )
  end
  
  # シングルトンであることをテスト
  public
  def test_singleton
    assert Lucie::Setup::include?( Singleton )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
