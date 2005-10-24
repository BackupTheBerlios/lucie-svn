package Vmlucie::Execute_vmware;
# vncでXを立ち上げる、その後仮想計算機を立ち上げる

use 5.008004;
use strict;
use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Vmlucie::Execute_vmware ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(execute_vmware
	
);

our $VERSION = '0.01';


# 引数は仮想計算機の名前
sub execute_vmware{
    my $vmname = shift;
    system("vncserver -depth 16 -geometry 800x600 :51");
    system("DISPLAY=:51 vmware -x -q $Vmlucie::Vmware_static::VM_CFG_DIR/$vmname.cfg");
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Execute_vmware - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Execute_vmware;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Execute_vmware, created by h2xs. It looks like the
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
