#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Taskrm < Test::Unit::TestCase
  public
  def test_commandline
    taskrm = InstallPackages::Command::Taskrm.new( { 'taskrm' => ['FOO', 'BAR', 'BAZ'] } )
    assert_equal( 'chroot /tmp/target tasksel -n remove FOO', 
                  taskrm.commandline[0],
                  '���ޥ�ɥ饤��ʸ�����������ʤ�' )
    assert_equal( 'chroot /tmp/target tasksel -n remove BAR', 
                  taskrm.commandline[1],
                  '���ޥ�ɥ饤��ʸ�����������ʤ�' )
    assert_equal( 'chroot /tmp/target tasksel -n remove BAZ', 
                  taskrm.commandline[2],
                  '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: