#
# $Id: tc_setup.rb 14 2005-01-19 06:32:24Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 1.6 $
# License::  GPL2

$LOAD_PATH.unshift '../lib'

require 'lucie/lucie-setup'
require 'test/unit'

class TC_Setup < Test::Unit::TestCase
  public
  def test_singleton
    assert Lucie::Setup::include?( Singleton )
  end
end

# FIXME
# o �ȉ��̃u���b�N���e�X�g�ŋ��ʉ�����B
# o TestRunner �̎�ނ� Rake �̃^�[�Q�b�g�ȂǂőI���\�Ȃ悤�ɂ���B
if __FILE__ == $0
  require 'test/unit/ui/tk/testrunner'
  require 'test/unit/testsuite'

  Test::Unit::UI::Tk::TestRunner.run( TC_Setup )
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
