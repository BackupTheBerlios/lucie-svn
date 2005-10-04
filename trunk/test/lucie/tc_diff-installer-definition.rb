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

  # 各アトリビュートへの代入と取得をテスト
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
    assert_equal( 'hotswap_nodes', diff_installer.name, "name アトリビュートが取得できない")
    assert_equal( 'condor_installer',  diff_installer.installers[0].name, "installers の第一要素の名前が正しくない" )
    assert_equal( 'compile_installer', diff_installer.installers[1].name, "installers の第二要素の名前が正しくない" )

    condor_installer_mock.__verify
    compile_installer_mock.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
