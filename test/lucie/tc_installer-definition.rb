#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lucie/config/installer'

class TC_InstallerDefinition < Test::Unit::TestCase
  public
  def test_accessor
    package_server = Mock.new( '#<PackageServer (Mock)>' )
    dhcp_server = Mock.new( '#<DHCPServer (Mock)>' )
    host_group = Mock.new( '#<HostGroup (Mock)>' )
    installer = Lucie::Config::Installer.new do |installer|
      installer.name                 = 'presto_installer'
      installer.alias               = 'Presto Cluster Installer'
      installer.address              = '192.168.1.200'
      installer.package_server       = package_server
      installer.kernel_version       = '2.2.18'
      installer.kernel_package       = 'kernel-image-2.4.27_lucie20040923_i386.deb'
      installer.dhcp_server          = dhcp_server
      installer.root_password        = 'xxxxxxxx'
      installer.host_group           = host_group
      installer.distribution         = 'debian'
      installer.distribution_version = 'woody'
    end
    
    assert_equal( 'presto_installer', installer.name )
    assert_equal( 'Presto Cluster Installer', installer.alias )
    assert_equal( '192.168.1.200', installer.address )
    assert_equal( package_server, installer.package_server )
    assert_equal( '2.2.18', installer.kernel_version )
    assert_equal( 'kernel-image-2.4.27_lucie20040923_i386.deb', installer.kernel_package )
    assert_equal( dhcp_server, installer.dhcp_server )
    assert_equal( 'xxxxxxxx', installer.root_password )
    assert_equal( host_group, installer.host_group )
    assert_equal( 'debian', installer.distribution )
    assert_equal( 'woody', installer.distribution_version )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
