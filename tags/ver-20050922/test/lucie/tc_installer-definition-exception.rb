#
# $Id: tc_host-definition-exception.rb 451 2005-03-25 08:50:01Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 451 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config'
require 'lucie/config/installer'
require 'test/unit'

class TC_InstallerDefinitionException < Test::Unit::TestCase
  public
  def setup
    host do |host|
      host.name = 'cluster_node00'
      host.alias = 'Cluster Node #00'
      host.address = '192.168.0.1'
      host.mac_address = '00:0C:29:41:88:FD'
    end
    
    host do |host|
      host.name = 'cluster_node01'
      host.alias = 'Cluster Node #01'
      host.address = '192.168.0.2'
      host.mac_address = '00:0C:29:41:88:FE'
    end

    package_server do |pkgserver|
      pkgserver.name         = 'debian_mirror'
      pkgserver.alias       = 'Local Debian Repository Mirror'
      pkgserver.uri          = 'http://192.168.1.100/debian/'
    end
    
    dhcp_server do |dhcp_server|
      dhcp_server.name            = 'dhcp'
      dhcp_server.alias          = 'Cluster DHCP Server'
      dhcp_server.nis_domain_name = 'yp.titech.ac.jp'
      dhcp_server.gateway         = '192.168.1.254'
      dhcp_server.address         = '192.168.1.200'
      dhcp_server.subnet          = '255.255.255.0'
      dhcp_server.dns             = '131.112.35.1'
      dhcp_server.domain_name     = 'is.titech.ac.jp'
    end

    host_group do |group|
      group.name = 'presto_cluster'
      group.alias = 'Presto Cluster'
      group.members = [Lucie::Config::Host['cluster_node00'], Lucie::Config::Host['cluster_node01']]    
    end
  end
  
  public
  def teardown
    Lucie::Config::Host.clear
    Lucie::Config::PackageServer.clear
  end

  public
  def test_name_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.name = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.name = '?'
      end
    end
  end

  public
  def test_name_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.name = 'aiUeo-kakikukeko_Sasisuseso'
      end
    end
  end
  
# ------------------------------------------------------------------------------
  
  public
  def test_alias_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.alias = ''
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.alias = "\n"
      end
    end
  end

  public
  def test_alias_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.alias = 'aiueo- bo Y 12_#'
      end
    end
  end
  
# ------------------------------------------------------------------------------

  public
  def test_address_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.address = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.address = '092.1.2.9'
      end
    end
  end
  
  public
  def test_address_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.address = '192.168.0.1'
      end
    end
  end
  
# ------------------------------------------------------------------------------

  public
  def test_package_server_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.package_server = 'package_server'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.package_server = Lucie::Config::Host['cluster_node00']
      end
    end
  end
  
  public
  def test_package_server_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.package_server = Lucie::Config::PackageServer['debian_mirror']
      end
    end
  end

# ------------------------------------------------------------------------------

  public
  def test_kernel_version_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.kernel_version = '2.4.1'
      end
    end
  end

# ------------------------------------------------------------------------------

  public
  def test_kernel_package_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.kernel_package = '20ab'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.kernel_package = '2.2.'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.kernel_package = 'kernel-image-2.4.27_lucie20040923_i386'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.kernel_package = 'kernl-image-2.4.27_lucie20040923_i386.deb'
      end
    end
  end
  
  public
  def test_kernel_package_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.kernel_package = 'kernel-image-2.4.27_lucie20040923_i386.deb'
      end
    end

    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.kernel_package = 'kernel-image-2.6.10-1-686.deb'
      end
    end
  end

# ------------------------------------------------------------------------------

  public
  def test_dhcp_server_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.dhcp_server = 'dhcp_server'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.dhcp_server = Lucie::Config::Host['cluster_node00']
      end
    end
  end
  
  public
  def test_dhcp_server_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.dhcp_server = Lucie::Config::DHCPServer['debian_mirror']
      end
    end
  end

# ------------------------------------------------------------------------------
  
  public
  def test_root_password_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.root_password = ''
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.root_password = "\010" # Backspace
      end
    end
  end

  public
  def test_root_password_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.root_password = 'aiueo- bo Y 12_# *%~'
      end
    end
  end
  
# ------------------------------------------------------------------------------

  public
  def test_host_group_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.host_group = 'host_group'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.host_group = Lucie::Config::Host['cluster_node00']
      end
    end
  end
  
  public
  def test_host_group_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.host_group = Lucie::Config::HostGroup['presto_cluster']
      end
    end
  end

# ------------------------------------------------------------------------------
  
  public
  def test_distribution_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.distribution = 'Turbo Linux'
      end
    end
  end

  public
  def test_distribution_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.distribution = 'Debian'
      end
    end

    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.distribution = 'RedHat'
      end
    end
  end

# ------------------------------------------------------------------------------
  
  public
  def test_distribution_version_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      installer do |installer|
        installer.distribution_version = ''
      end
    end
  end

  public
  def test_distribution_version_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      installer do |installer|
        installer.distribution_version = 'woody'
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
