#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lmp/specification'
require 'test/unit'

class TC_Specification < Test::Unit::TestCase
  public
  def setup
    @specification = LMP::Specification.new
  end

  public
  def test_to_s
    assert_equal( %{#<LMP::Specification name= version=>}, @specification.to_s,
                  "Specification#to_s の返り値が正しくない" )
  end

  public
  def test_inspect
    assert_equal( %{#<LMP::Specification name= version=>}, @specification.inspect,
                  "Specification#inspect の返り値が正しくない" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
