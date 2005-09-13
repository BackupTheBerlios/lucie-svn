#
# $Id: state.rb 663 2005-06-02 06:45:58Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 663 $
# License::  GPL2

$LOAD_PATH.unshift './lib'
require 'deft/state'
require 'mock'
require 'test/unit'

class TC_State < Test::Unit::TestCase
  public
  def test_inspect
    state = Deft::State.instance
    assert_equal( '#<State: @name="", @first_state="">', state.inspect )

    question = Mock.new( '#<Question (Mock)>' )
    question.__next( :name ) do "NAME" end
    question.__next( :priority ) do "PRIORITY" end
    question.__next( :first_question ) do "FIRST STATE" end
    state.enhance( question )
    assert_equal( '#<State: @name="NAME", @first_state="FIRST STATE">', state.inspect )
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
