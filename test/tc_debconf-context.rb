#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

ENV["DEBIAN_HAS_FRONTEND"] = 'true' # debconf/client.rb ‚ÌƒGƒ‰[‚ğ‰ñ”ğ
ENV["DEBCONF_RUBY_STDOUT"] = '1'

$LOAD_PATH.unshift './lib'

require 'lucie/debconf-context'
require 'test/unit'

class TC_DebconfContext < Test::Unit::TestCase
  public
  def test_start_state
    require 'test/lmp_conf/lucie_vm_template'
    require 'test/lmp_conf/lucie_vm_question'
    
    debconf_context = DebconfContext.new
    assert_kind_of Lucie::State, debconf_context.current_state
    assert_equal 'Lucie::State::LucieVmsetup__Hello', debconf_context.current_state.class.to_s
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
