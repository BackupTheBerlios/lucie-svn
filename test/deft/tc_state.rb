#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'test/unit'

class TC_State < Test::Unit::TestCase
  public
  def setup
    ENV["DEBIAN_HAS_FRONTEND"] = 'true'
    require 'deft/state'
  end
  
  # transit メソッドで正しい文字列が Debconf フロントエンドへ送られることを確認
  public
  def test_transit    
    debconf_context = Mock.new( '[DEBCONF CONTEXT]' )
    current_question = Mock.new( '[CURRENT QUESTION]' )
    stdout = Mock.new( '[STDOUT]' )
    stdout.__next( :print ) do |response| 
      assert_equal "INPUT MEDIUM TEST-QUESTION\n", response, "期待していた Debconf の input コマンドと違う"
    end
    stdout.__next( :print ) do |response| 
      assert_equal "GO\n", response, "期待していた Debconf の go コマンドと違う"
    end
    stdin = Mock.new( '[STDIN]' )
    stdin.__next( :gets ) do || '0 TEST' end
    stdin.__next( :gets ) do || '0 TEST' end
    
    debconf_context.__next( :stdout ) do || stdout end
    debconf_context.__next( :stdin ) do || stdin end
    debconf_context.__next( :current_question ) do || current_question end
    current_question.__next( :priority ) do || 'MEDIUM' end
    debconf_context.__next( :current_question ) do || current_question end
    current_question.__next( :name ) do || 'TEST-QUESTION' end
    
    Deft::State.instance.transit debconf_context   
    
    stdout.__verify
    stdin.__verify
    debconf_context.__verify
    current_question.__verify
  end
  
  # 親が BooleanState の concrete class のオブジェクトが生成されることを確認
  public
  def test_define_boolean_state
    boolean_question = Mock.new( '[BOOLEAN QUESTION]' )
    boolean_question.__next( :template ) do || Deft::BooleanState end
    boolean_question.__next( :name ) do || 'TEST/BOOLEAN-QUESTION' end
    boolean_question.__next( :name ) do || 'TEST/BOOLEAN-QUESTION' end
    boolean_question.__next( :name ) do || 'TEST/BOOLEAN-QUESTION' end
    
    state = Deft::State.concrete_state( boolean_question )
    assert_equal 'Deft::State::Test__BooleanQuestion', state.class.to_s, "生成された state のクラス名が違う"
    assert_equal Deft::BooleanState, state.class.superclass, "生成された state の親クラスが違う"
    
    boolean_question.__verify
  end
  
  # marshal_concrete_state メソッドがアブストラクトであることを確認
  public
  def test_marshal_concrete_state_not_implemented
    assert_raises( NotImplementedError, "NotImplementedError が raise されなかった" ) do
      Deft::State::marshal_concrete_state nil
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
