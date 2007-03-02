#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Taskinst < Test::Unit::TestCase
  public
  def test_taskinst_string_arg
    taskinst_command = taskinst( 'FOO' )
    assert_equal( 'chroot /tmp/target tasksel -n install FOO', 
                  taskinst_command.commandline[0],
                  '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end

  public
  def test_taskinst
    taskinst_command = taskinst(['FOO', 'BAR', 'BAZ'])
    assert_equal( 'chroot /tmp/target tasksel -n install FOO', 
                  taskinst_command.commandline[0],
                  '���ޥ�ɥ饤��ʸ�����������ʤ�' )
    assert_equal( 'chroot /tmp/target tasksel -n install BAR', 
                  taskinst_command.commandline[1],
                  '���ޥ�ɥ饤��ʸ�����������ʤ�' )
    assert_equal( 'chroot /tmp/target tasksel -n install BAZ', 
                  taskinst_command.commandline[2],
                  '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
