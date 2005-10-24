package Vmlucie::Read_admin_cfg;

use 5.008004;
use strict;
use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);


our @EXPORT = qw(read_admin_cfg pkgserver_name pkgserver_uri dhcpserver_name dhcpserver_addr dhcpserver_gateway dhcpserver_subnet dhcpserver_dns dhcpserver_domain installer_addr installer_kernel_path installer_kernel_version installer_root_passwd remote_shell);

our $VERSION = '0.01';

my $pkgserver_name;
my $pkgserver_uri;
my $dhcpserver_name;
my $dhcpserver_addr;
my $dhcpserver_gateway; 
my $dhcpserver_subnet;
my $dhcpserver_dns;
my $dhcpserver_domain;
my $installer_addr;
my $installer_kernel_path;
my $installer_kernel_version;
my $installer_root_passwd;
my $remote_shell;

# 管理者の用意した設定ファイルをもとに変数を設定する
sub read_admin_cfg{
    my $argc = $#_;
    if ($argc != -1 && $argc !=0){
	die "引数はなし、もしくはコンフィグのパスを指定してください\n";
    }
    init();
    if ($argc == 0){
	read_file(shift);
    }
}

sub init{
    $pkgserver_name = "debianorg";
    $pkgserver_uri = "http://203.178.137.175/debian";
    $dhcpserver_name = "localhost";
    $dhcpserver_addr = "192.168.0.253";
    $dhcpserver_gateway = "192.168.0.254"; 
    $dhcpserver_subnet = "255.255.255.0";
    $dhcpserver_dns = "192.168.0.254";
    $dhcpserver_domain = "localdomain";
    $installer_addr = "192.168.0.253";
    $installer_kernel_path = "/etc/lucie/kernel/kernel-image-2.4.27_i386.deb";
    $installer_kernel_version = "2.4.27";
    $installer_root_passwd = "SD6KRQvJru6u2";
    $remote_shell = "ssh";
}

sub read_file{
    my $filename = shift;
    my $line;
    open(FILE, "$filename") or die "unabled to open $filename\n";
    
    for $line (<FILE>){
        if ($line =~/^pkgserver_name\s+(\S+)/){
            $pkgserver_name = $1;
        }elsif ($line =~/^pkgserver_uri\s+(\S+)/){
            $pkgserver_uri = $1;
        }elsif ($line =~/^dhcpserver_name\s+(\S+)/){
            $dhcpserver_name = $1;
        }elsif ($line =~/^dhcpserver_addr\s+(\S+)/){
            $dhcpserver_addr = $1;
        }elsif ($line =~/^dhcpserver_gateway\s+(\S+)/){
            $dhcpserver_gateway = $1;
        }elsif ($line =~/^dhcpserver_subnet\s+(\S+)/){
            $dhcpserver_subnet = $1;
        }elsif ($line =~/^dhcpserver_dns\s+(\S+)/){
            $dhcpserver_dns = $1;
	}elsif ($line =~/^dhcpserver_domain\s+(\S+)/){
            $dhcpserver_domain = $1;
	}elsif ($line =~/^installer_addr\s+(\S+)/){
            $installer_addr = $1;
	}elsif ($line =~/^installer_kernel_path\s+(\S+)/){
            $installer_kernel_path = $1;
	}elsif ($line =~/^installer_kernel_version\s+(\S+)/){
            $installer_kernel_version = $1;
	}elsif ($line =~/^installer_root_passwd\s+(\S+)/){
            $installer_root_passwd = $1;
	}elsif ($line =~/^remote_shell\s+(\S+)/){
            $remote_shell = $1;
	}
    }

    close(FILE);    
}

sub pkgserver_name{
    return $pkgserver_name;
}

sub pkgserver_uri{
    return $pkgserver_uri;
}

sub dhcpserver_name{
    return $dhcpserver_name;
}

sub dhcpserver_addr{
    return $dhcpserver_addr;
}

sub dhcpserver_gateway{
    return $dhcpserver_gateway;
}

sub dhcpserver_subnet{
    return $dhcpserver_subnet;
}

sub dhcpserver_dns{
    return $dhcpserver_dns;
}

sub dhcpserver_domain{
    return $dhcpserver_domain;
}

sub installer_addr{
    return $installer_addr;
}

sub installer_kernel_path{
    return $installer_kernel_path;
}

sub installer_kernel_version{
    return $installer_kernel_version;
}

sub installer_root_passwd{
    return $installer_root_passwd;
}

sub remote_shell{
    return $remote_shell;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Read_admin_cfg - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Read_admin_cfg;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Read_admin_cfg, created by h2xs. It looks like the
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
