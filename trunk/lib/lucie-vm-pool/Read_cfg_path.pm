package Vmlucie::Read_cfg_path;

use 5.008004;
use strict;
use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(read_cfg_path resource_path)]);

our @EXPORT_OK = (@{ $EXPORT_TAGS{'all'}});

our @EXPORT = qw(read_cfg_path resource_path pkgdir_path admin_cfg_path client_cfg_path xen_ip_list_path vmware_ip_list_path tmpdir_path);


my $resource_path;
my $pkgdir_path;
my $admin_cfg_path;
my $client_cfg_path;
my $xen_ip_list_path;
my $vmware_ip_list_path;
my $tmpdir_path;

our $VERSION = '0.01';
# 管理者が用意したコンフィグのパスを読み込む
# 引数としてコンフィグファイルのパスを指定
# 無かった場合初期値が与えられる
sub read_cfg_path{
    my $argc = $#_;
    if ($argc != -1 && $argc != 0){
	die "引数はなし、もしくはコンフィグのパスを指定してください";
    }
    init();
    if ($argc == 0){

	read_file(shift);
    }
}

sub init{
    $resource_path = "/etc/lucie/resource.rb";
    $pkgdir_path = "/etc/lucie";
    $admin_cfg_path = "/var/lib/vmlucie/admin.cfg";
    $client_cfg_path = "/var/lib/vmlucie/vmconfig";
    $xen_ip_list_path = "/var/lib/vmlucie/xen_ip.list";
    $vmware_ip_list_path = "/var/lib/vmlucie/vmware_ip.list";
    $tmpdir_path = "/tmp";
}

sub read_file{
    my $filename = shift;
    my $line;
    open(FILE, "$filename") or die "unabled to open $filename\n";

    for $line (<FILE>){
        if ($line =~/^resource_path\s+(\S+)/){
            $resource_path = $1;
        }elsif ($line =~/^pkgdir_path\s+(\S+)/){
            $pkgdir_path = $1;
	}elsif ($line =~/^admin_cfg_path\s+(\S+)/){
	    $admin_cfg_path = $1;
        }elsif ($line =~/^client_cfg_path\s+(\S+)/){
            $client_cfg_path = $1;
        }elsif ($line =~/^xen_ip_list_path\s+(\S+)/){
            $xen_ip_list_path = $1;
        }elsif ($line =~/^vmware_ip_list_path\s+(\S+)/){
            $vmware_ip_list_path = $1;
        }elsif ($line =~/^tmpdir_path\s+(\S+)/){
            $tmpdir_path = $1;
        }
    }
    close(FILE);
}

sub resource_path{
    return $resource_path;
}

sub pkgdir_path{
    return $pkgdir_path;
}

sub admin_cfg_path{
    return $admin_cfg_path;
}

sub client_cfg_path{
    return $client_cfg_path;
}

sub xen_ip_list_path{
    return $xen_ip_list_path;
}

sub vmware_ip_list_path{
    return $vmware_ip_list_path;
}

sub tmpdir_path{
    return $tmpdir_path;
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Read_cfg_path - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Read_cfg_path;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Read_cfg_path, created by h2xs. It looks like the
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
