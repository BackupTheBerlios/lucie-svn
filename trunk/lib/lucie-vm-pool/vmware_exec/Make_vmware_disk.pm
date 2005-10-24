package Vmlucie::Make_vmware_disk;
# VMwareのディスクを作成する

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

# This allows declaration	use Vmlucie::Make_vmware_disk ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(make_vmware_disk
	
);

our $VERSION = '0.01';


# 引数はvmの名前とdiskのサイズ
sub make_vmware_disk{
    my $vmname = shift;
    my $hdd = shift;
    
    system ("rm -f $Vmlucie::Vmware_static::VM_DISK_DIR/$vmname.vmdk");
    system ("vmware-vdiskmanager -c -s $hdd -a buslogic -t 0 $Vmlucie::Vmware_static::VM_DISK_DIR/$vmname.vmdk");
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Make_vmware_disk - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Make_vmware_disk;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Make_vmware_disk, created by h2xs. It looks like the
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
