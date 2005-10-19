package Make_resource_cfg;
# lucieのメインの設定ファイルであるresource.rbを作成する

use 5.008004;
use strict;
use warnings;
use Carp;

use Global;
use Lucie_cfg;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(make_resource_cfg
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(make_resource_cfg
	
);


my $node_number;
my $vm;
my @list;

# 引数は構築するvmの数とvmの種類、構築するマシンのリスト
sub make_resource_cfg{

    $node_number = shift;
    $vm = shift;
    @list = @_;
    open_resource_file();
    setting_hosts();
    setting_group();
    setting_pkgserver();
    setting_dhcpserver();
    setting_installer();
}

sub open_resource_file{
    open(FILE,">$Global::tmpdir/resource.rb") or die "cannot make $Global::tmpdir/resource.rb";
    print FILE <<EOF;
require 'lucie/config'
include Lucie::Config

EOF
}

sub setting_hosts{
    my $i = 0;
    for ($i = 0; $i<$node_number; $i++){
	my $host  =  shift @list;
	my $mac = shift @list;
	my $ip = shift @list;

	print FILE <<EOF;
host do |host|
    host.name        = '$vm$i'
    host.address     = '$ip'
    host.mac_address = '$mac'
end

EOF
     }
}

sub setting_group{
    my $i;
    
    print FILE "host_group do |group|\n";
    print FILE "\tgroup.name    = 'group'\n";
    print FILE "\tgroup.members = [";

    for ($i=0; $i<$node_number; $i++){
        print FILE "Host['$vm$i']";
	if ($i+1 != $node_number){
	    print FILE ", ";
	}
    }
    print FILE "]\n";
    print FILE "end\n\n";
}

sub setting_pkgserver{
    print FILE <<EOF;
package_server do |pkgserver|
    pkgserver.name = '$Lucie_cfg::package_server_name'
    pkgserver.uri  = '$Lucie_cfg::package_server_uri'
end

EOF
}

sub setting_dhcpserver{
    print FILE <<EOF;
dhcp_server do |dhcp_server|
    dhcp_server.name        = '$Lucie_cfg::dhcp_server_name'
    dhcp_server.address     = '$Lucie_cfg::dhcp_server_address'
    dhcp_server.gateway     = '$Lucie_cfg::dhcp_server_gateway'
    dhcp_server.subnet      = '$Lucie_cfg::dhcp_server_subnet'
    dhcp_server.dns         = '$Lucie_cfg::dhcp_server_dns'
    dhcp_server.domain_name = '$Lucie_cfg::dhcp_server_domain_name'
end

EOF
}

sub setting_installer{
    my $installer = "-installer";
    substr($installer, 0, 0) = $vm;

    print FILE <<EOF;
installer do |installer|
    installer.name                 = '$installer'
    installer.address              = '$Lucie_cfg::installer_address'
    installer.host_group           = HostGroup['group']
    installer.package_server       = PackageServer['$Lucie_cfg::package_server_name']
    installer.dhcp_server          = DHCPServer['$Lucie_cfg::dhcp_server_name']
    installer.kernel_package       = '$Lucie_cfg::installer_kernel_path'
    installer.kernel_version       = '$Lucie_cfg::installer_kernel_version'
    installer.root_password        = '$Lucie_cfg::installer_root_passwd'
    installer.distribution         = 'debian'
    installer.distribution_version = 'sarge'
    installer.extra_packages       = ['libdevmapper1.01', 'lv']
end
EOF

    close(FILE);
}

1;
__END__
