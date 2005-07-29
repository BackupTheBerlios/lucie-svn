#
# $Id: tc_aptitude-r.rb 794 2005-07-29 01:58:07Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 794 $
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Preload < Test::Unit::TestCase
  
  # aptitude_r コマンドの preload 動作のテスト ------------------------------------------

  public
  def test_aptitude_r_preload_wget
    aptitude_r_command = aptitude_r do |aptitude_r|
      aptitude_r.preload << { :url => %{http://foo.bar/baz.tgz}, :directory => %{preload} }
      aptitude_r.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{wget -nv -P/tmp/target/preload http://foo.bar/baz.tgz},
                  aptitude_r_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_aptitude_r_preload_cp
    aptitude_r_command = aptitude_r do |aptitude_r|
      aptitude_r.preload << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      aptitude_r.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{cp /etc/lucie//tmp/FOO.TGZ /tmp/target/preload},
                  aptitude_r_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  # aptitude コマンドの preload 動作のテスト --------------------------------------------

  public
  def test_aptitude_preload_wget
    aptitude_command = aptitude do |aptitude|
      aptitude.preload << { :url => %{http://foo.bar/baz.tgz}, :directory => %{preload} }
      aptitude.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{wget -nv -P/tmp/target/preload http://foo.bar/baz.tgz},
                  aptitude_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_aptitude_preload_cp
    aptitude_command = aptitude do |aptitude|
      aptitude.preload << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      aptitude.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{cp /etc/lucie//tmp/FOO.TGZ /tmp/target/preload},
                  aptitude_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  # install コマンドの preload 動作のテスト ---------------------------------------------

  public
  def test_install_preload_wget
    install_command = install do |install|
      install.preload << { :url => %{http://foo.bar/baz.tgz}, :directory => %{preload} }
      install.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{wget -nv -P/tmp/target/preload http://foo.bar/baz.tgz},
                  install_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end
  
  public
  def test_install_preload_cp
    install_command = install do |install|
      install.preload << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      install.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{cp /etc/lucie//tmp/FOO.TGZ /tmp/target/preload},
                  install_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
