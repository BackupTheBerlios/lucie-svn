package Vmlucie::Execute_xen;
# xenをnfsrootで起動する。インストール終了後自動的にシャットダウンするので、それを確認後通常の設定ファイルで起動する

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

# This allows declaration	use Vmlucie::Execute_xen ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(execute_xen
	
);

our $VERSION = '0.01';


# 引数は仮想計算機の名前
sub execute_xen{
    my $vmname = shift;

    my $rootcfg = "$Vmlucie::Xen_static::VM_CFG_DIR/$vmname.nfsroot_cfg";
    my $execcfg = "$Vmlucie::Xen_static::VM_CFG_DIR/$vmname.exec_cfg";
    system ("/usr/sbin/xm create $rootcfg");

    sleep(2);
    
    my $ret;
    while (($ret = system("/usr/sbin/xm list $vmname >& /dev/null")) == 0){
        sleep(5);
    }

    system ("/usr/sbin/xm create $execcfg");
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Execute_xen - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Execute_xen;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Execute_xen, created by h2xs. It looks like the
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
