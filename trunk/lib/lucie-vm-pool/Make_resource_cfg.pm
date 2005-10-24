package Vmlucie::Make_resource_cfg;
# lucieのメインの設定ファイルであるresource.rbを作成する
# これを実行する前にread_admin_cfgを実行しておく必要がある。

use 5.008004;
use strict;
use warnings;
use Carp;

use Vmlucie::Read_admin_cfg;

require Exporter;


our @ISA = qw(Exporter);

our @EXPORT = qw(make_resource_cfg);

our $VERSION = '0.01';


# Preloaded methods go here.
my $node_number;
my $vm;
my $tmpdir_path;
my @list;

# 引数は構築するvmの数とvmの種類、tmpdirのパス、構築するマシンのリスト
sub make_resource_cfg{
    
    $node_number = shift;
    $vm = shift;
    $tmpdir_path = shift;
    @list = @_;

    open_resource_file();
    setting_hosts();
    setting_group();
    setting_pkgserver();
    setting_dhcpserver();
    setting_installer();
}

sub open_resource_file{
    open(FILE,">$tmpdir_path/resource.rb") or die "unabled to make $tmpdir_path/resource.rb";
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
    my $name = pkgserver_name();
    my $uri = pkgserver_uri();
    print FILE <<EOF;
package_server do |pkgserver|
    pkgserver.name = '$name'
    pkgserver.uri  = '$uri'
end

EOF
}

sub setting_dhcpserver{
    my $name = dhcpserver_name();
    my $addr = dhcpserver_addr();
    my $gateway = dhcpserver_gateway();
    my $subnet = dhcpserver_subnet();
    my $dns = dhcpserver_dns();
    my $domain = dhcpserver_domain();
    print FILE <<EOF;
dhcp_server do |dhcp_server|
    dhcp_server.name        = '$name'
    dhcp_server.address     = '$addr'
    dhcp_server.gateway     = '$gateway'
    dhcp_server.subnet      = '$subnet'
    dhcp_server.dns         = '$dns'
    dhcp_server.domain_name = '$domain'
end

EOF
}

sub setting_installer{
    my $installer = "-installer";
    substr($installer, 0, 0) = $vm;

    my $installer_addr = installer_addr();
    my $pkgserver_name = pkgserver_name();
    my $dhcpserver_name = dhcpserver_name();
    my $installer_kernel_path = installer_kernel_path();
    my $installer_kernel_version = installer_kernel_version();
    my $installer_root_passwd = installer_root_passwd();

    print FILE <<EOF;
installer do |installer|
    installer.name                 = '$installer'
    installer.address              = '$installer_addr'
    installer.host_group           = HostGroup['group']
    installer.package_server       = PackageServer['$pkgserver_name']
    installer.dhcp_server          = DHCPServer['$dhcpserver_name']
    installer.kernel_package       = '$installer_kernel_path'
    installer.kernel_version       = '$installer_kernel_version'
    installer.root_password        = '$installer_root_passwd'
    installer.distribution         = 'debian'
    installer.distribution_version = 'sarge'
    installer.extra_packages       = ['libdevmapper1.01', 'lv']
end
EOF
    
    close(FILE);
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Make_resource_cfg - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Make_resource_cfg;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Make_resource_cfg, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

ikuhei yamagata, E<lt>ikuhei@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by ikuhei yamagata

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.


=cut
