#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/boolean-template'
require 'test/unit'

class TC_BooleanTemplate < Test::Unit::TestCase
  # 親クラスが Lucie::Template であることをテスト
  public
  def test_inheritance
    assert Lucie::BooleanTemplate < Lucie::Template
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
