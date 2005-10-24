package Vmlucie::Make_xen_cfg;
# nfsroot用と通常起動用の設定ファイルを作成する

use 5.008004;
use strict;
use warnings;
use Carp;

use Vmlucie::Xen_static;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Vmlucie::Make_xen_cfg ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(make_nfsroot_cfg make_exec_cfg
	
);

our $VERSION = '0.01';


# Xenのインストール用のコンフィグファイルを作成する
# 引数はvmの名前、メモリ、macアドレス、ipアドレス、netmask、gatewayのアドレス、nfsrootサーバーのアドレス、nfsrootのパス
sub make_nfsroot_cfg{
    my $vmname = shift;
    my $memory = shift;
    my $mac = shift;
    my $ip = shift;
    my $netmask = shift;
    my $gateway = shift;
    my $nfsaddr = shift;
    my $nfspath = shift;

    my $vmcfg = "$Vmlucie::Xen_static::VM_CFG_DIR/$vmname.nfsroot_cfg";

    open(FILE, ">$vmcfg") or die "unabled to make $vmcfg\n";

    print FILE <<EOF
#  -*- mode: python; -*-
kernel = "$Vmlucie::Xen_static::KERNEL"

memory = $memory

name = "$vmname"

vif = [ 'mac=$mac, bridge=xen-br0' ]

disk = [ 'file:$Vmlucie::Xen_static::VM_DISK_DIR/$vmname.disk,sda1,w' ]

ip="$ip"

netmask="$netmask"

gateway="$gateway"

hostname= "$vmname"

root = "/dev/nfs"

nfs_server = '$nfsaddr'  

nfs_root   = '$nfspath'

extra = "4"

EOF
}

# 通常起動用のコンフィグファイルを作成する
# 引数は仮想計算機の名前とmemoryとmacアドレス
sub make_exec_cfg{
   
    my $vmname = shift;
    my $memory = shift;
    my $mac = shift;
    
    my $vmcfg = "$Vmlucie::Xen_static::VM_CFG_DIR/$vmname.exec_cfg";

    open(FILE, ">$vmcfg") or die "unabled to make $vmcfg\n";

    print FILE <<EOF
#  -*- mode: python; -*-
kernel = "$Vmlucie::Xen_static::KERNEL"

memory = $memory

name = "$vmname"

vif = [ 'mac=$mac, bridge=xen-br0' ]

disk = [ 'file:$Vmlucie::Xen_static::VM_DISK_DIR/$vmname.disk,sda1,w' ]

root = "/dev/sda1 ro"

extra = "4"

EOF

}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Make_xen_cfg - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Make_xen_cfg;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Make_xen_cfg, created by h2xs. It looks like the
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
