#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Preloadrm < Test::Unit::TestCase
  # aptitude_r ���ޥ�ɤ� preloadrm ư��Υƥ��� -----------------------------------------
  public
  def test_aptitude_r_preloadrm
    aptitude_r_command = aptitude_r do |aptitude_r|
      aptitude_r.preloadrm << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      aptitude_r.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{rm /tmp/target/preload/FOO.TGZ},
                  aptitude_r_command.commandline[2], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end

  # aptitude ���ޥ�ɤ� preloadrm ư��Υƥ��� -------------------------------------------
  public
  def test_aptitude_preloadrm
    aptitude_command = aptitude do |aptitude|
      aptitude.preloadrm << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      aptitude.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{rm /tmp/target/preload/FOO.TGZ},
                  aptitude_command.commandline[3], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end
  
  # install ���ޥ�ɤ� preloadrm ư��Υƥ��� --------------------------------------------
  public
  def test_install_preloadrm
    install_command = install do |install|
      install.preloadrm << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      install.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{rm /tmp/target/preload/FOO.TGZ}, install_command.commandline[3],
                  '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
