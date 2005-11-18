#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config'
require 'lucie/config/installer'
require 'test/mock'
require 'test/unit'

class TC_InstallerDefinition < Test::Unit::TestCase
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
      pkgserver.alias        = 'Local Debian Repository Mirror'
      pkgserver.uri          = 'http://192.168.1.100/debian/'
    end
    
    dhcp_server do |dhcp_server|
      dhcp_server.name            = 'dhcp'
      dhcp_server.alias           = 'Cluster DHCP Server'
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
      group.members = [Lucie::Config::Host['cluster_node00'],
        Lucie::Config::Host['cluster_node01']]    
    end
  end
 
  public
  def teardown
    Lucie::Config::Installer.clear
  end
  
  public
  def test_accessor
    package_server = Mock.new( '#<PackageServer (Mock)>' )
    dhcp_server = Mock.new( '#<DHCPServer (Mock)>' )
    host_group = Mock.new( '#<HostGroup (Mock)>' )
    installer = Lucie::Config::Installer.new do |installer|
      installer.name                 = 'presto_installer'
      installer.alias                = 'Presto Cluster Installer'
      installer.address              = '192.168.1.200'
      installer.package_server       = Lucie::Config::PackageServer['debian_mirror']
      installer.kernel_version       = '2.2.18'
      installer.kernel_package       = 'kernel-image-2.4.27_lucie20040923_i386.deb'
      installer.dhcp_server          = Lucie::Config::DHCPServer['dhcp']
      installer.root_password        = 'xxxxxxxx'
      installer.host_group           = Lucie::Config::HostGroup['presto_cluster']
      installer.distribution         = 'debian'
      installer.distribution_version = 'woody'
    end
    
    assert_equal( 'presto_installer', installer.name )
    assert_equal( 'Presto Cluster Installer', installer.alias )
    assert_equal( '192.168.1.200', installer.address )
    assert_equal( Lucie::Config::PackageServer['debian_mirror'], installer.package_server )
    assert_equal( '2.2.18', installer.kernel_version )
    assert_equal( 'kernel-image-2.4.27_lucie20040923_i386.deb', installer.kernel_package )
    assert_equal( Lucie::Config::DHCPServer['dhcp'], installer.dhcp_server )
    assert_equal( 'xxxxxxxx', installer.root_password )
    assert_equal( Lucie::Config::HostGroup['presto_cluster'], installer.host_group )
    assert_equal( 'debian', installer.distribution )
    assert_equal( 'woody', installer.distribution_version )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
