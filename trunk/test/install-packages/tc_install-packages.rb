#
# $Id: tc_abstract-template.rb 645 2005-06-01 07:08:14Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 645 $
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'pp'
require 'install-packages'
require 'test/unit'

class TC_InstallPackages < Test::Unit::TestCase
  public
  def setup
    @install_packages = InstallPackages::App.instance
  end

  public
  def test_do_commands
    $dry_run = true
    @install_packages.read_config( 'test/install-packages/install-packages.conf' )
    @install_packages.do_commands
  end

  public
  def test_fetch_prerequires
    $dry_run = true
    @install_packages.read_config( 'test/install-packages/install-packages.conf' )
    @install_packages.fetch_prerequires
  end

  public
  def test_read_config_raises_exception
    assert_raises( Errno::ENOENT, '例外が raise されなかった' ) do 
      @install_packages.read_config( 'NO_SUCH_FILE' )
    end
  end

  public
  def test_read_config
    list = @install_packages.read_config( 'test/install-packages/install-packages.conf' )
    assert_equal( ['install'], list.keys,
                  'インストールタイプの数が正しくない' )
    assert_equal( packages_tobeinstalled, list['install'],
                  'インストールされるパッケージが正しくない' )
  end

  public
  def packages_tobeinstalled
    return %w(ssh hdparm cron linuxlogo tcsh file less cfengine rsync jove rstat-client rstatd rusers rusersd rsh-client rsh-server module-init-tools sysutils time strace rdate nfs-common nscd)
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
