package Vmlucie::Make_vmware_cfg;
# VMwareのコンフィグファイルを作成する

use 5.008004;
use strict;
use warnings;
use Carp;

use Vmlucie::Vmware_static;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Vmlucie::Make_vmware_cfg ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(make_vmware_cfg
	
);

our $VERSION = '0.01';


# 引数は仮想計算機の名前とmemoryのサイズとMACアドレス
sub make_vmware_cfg{

    # 仮想計算機の名前
    my $vmname = shift;
    # メモリのサイズ
    my $memory = shift;
    # MACアドレス
    my $mac = shift;


    my $vmcfg = "$Vmlucie::Vmware_static::VM_CFG_DIR/$vmname.cfg";
    
    system ("rm -f $vmcfg");
    open(FILE, ">$vmcfg") or die "unabled to make $vmcfg\n ";
    
    print FILE <<EOF
#!/usr/bin/vmware
config.version = 7
virtualHW.version = 3
displayName = "$vmname"

scsi0.present = TRUE
scsi0:0.present =TRUE
scsi0:0.fileName = $Vmlucie::Vmware_static::VM_DISK_DIR/$vmname.vmdk
scsi0:0.deviceType = scsi-hardDisk
scsi0:0.mode = persistent
scsi0:0.writethrough = FALSE

floppy0.present = FALSE

ethernet0.present = TRUE
ethernet0.connectionType = bridged
ethernet0.address = $mac


memsize = "$memory"

nvram = $Vmlucie::Vmware_static::VM_NVRAM_DIR/$vmname.nvram

log.fileName = $Vmlucie::Vmware_static::VM_LOG_DIR/$vmname.log

guestOS = linux

Ethernet0.addressType = "static"
priority.grabbed = "normal"
priority.ungrabbed = "normal"
tools.remindInstall = "TRUE"
EOF

}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Make_vmware_cfg - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Make_vmware_cfg;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Make_vmware_cfg, created by h2xs. It looks like the
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
