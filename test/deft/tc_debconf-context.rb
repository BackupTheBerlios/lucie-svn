#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

ENV["DEBIAN_HAS_FRONTEND"] = 'true' # debconf/client.rb のエラーを回避

$LOAD_PATH.unshift './lib'

require 'deft/debconf-context'
require 'test/unit'

class TC_DebconfContext < Test::Unit::TestCase
  #--
  # FIXME : Question と対応する Template の require の順でエラーが起こる。Template の無い Question を定義しようとすると例外を投げるようにする。
  #++
  public
  def test_start_state
    require 'test/lmp_conf/lucie_vm_template'
    require 'test/lmp_conf/lucie_vm_question'    
    
    debconf_context = Deft::DebconfContext.new
    assert_kind_of Deft::State, debconf_context.current_state
    assert_equal 'Deft::State::LucieVmsetup__Hello', debconf_context.current_state.class.to_s
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
