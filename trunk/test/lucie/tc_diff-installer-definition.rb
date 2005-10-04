#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config/diff-installer'
require 'mock'
require 'test/unit'

class TC_DiffInstallerDefinition < Test::Unit::TestCase
  public
  def teardown
    Lucie::Config::DiffInstaller.clear
  end

  # �ƥ��ȥ�ӥ塼�Ȥؤ������ȼ�����ƥ���
  public
  def test_attributes
    condor_installer_mock = Mock.new( "#<Lucie::Config::Installer (Mock)>" )
    condor_installer_mock.__next( :name ) do 'condor_installer' end
    compile_installer_mock = Mock.new( "#<Lucie::Config::Installer (Mock)>" )
    compile_installer_mock.__next( :name ) do 'compile_installer' end

    diff_installer = Lucie::Config::DiffInstaller.new do |diff_installer|
      diff_installer.name = 'hotswap_nodes'
      diff_installer.installers = [condor_installer_mock, compile_installer_mock]
    end
    assert_equal( 'hotswap_nodes', diff_installer.name, "name ���ȥ�ӥ塼�Ȥ������Ǥ��ʤ�")
    assert_equal( 'condor_installer',  diff_installer.installers[0].name, "installers ��������Ǥ�̾�����������ʤ�" )
    assert_equal( 'compile_installer', diff_installer.installers[1].name, "installers ���������Ǥ�̾�����������ʤ�" )

    condor_installer_mock.__verify
    compile_installer_mock.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
