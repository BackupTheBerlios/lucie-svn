package Vmlucie::Vm_boot;
#���۷׻�����Ω���夲��Ρ��ɤ��Ф��ơ�Ω���夲�륳�ޥ�ɤ��⡼�ȥ�����Ǥ�Ф�
#������vm�μ��ࡢΩ���夲��׻����ο���memory�����̡�hdd�����̡���⡼�ȥ�����μ��ࡢ�Ρ��ɥꥹ��

use 5.008004;
use strict;
use warnings;
use Carp;

use Vmlucie::Read_admin_cfg;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Vmlucie::Vm_boot ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(vm_boot
	
);

our $VERSION = '0.01';


# Preloaded methods go here.
sub vm_boot{
    my $vm = shift;
    my $node_num = shift;
    my $memory = shift;
    my $hdd = shift;
    my @node_list = @_;
    my $i;

    my $remote_shell = "ssh";

    for ($i = 0; $i < $node_num; $i++){
	my $host = shift @node_list;
	my $mac = shift @node_list;
	my $ip = shift @node_list;
	
	if ($vm eq "vmware"){
	    system("$remote_shell $host make_vmware.pl vmware$i $mac $memory $hdd &");
	}elsif ($vm eq "xen"){
	    my $dhcpserver_subnet = dhcpserver_subnet();
	    my $dhcpserver_gateway = dhcpserver_gateway();
	    my $dhcpserver_addr = dhcpserver_addr();
	    system("$remote_shell $host /home/ikuhei/xen_exec/make_xen.pl xen$i $memory $mac $hdd $ip $dhcpserver_subnet $dhcpserver_gateway $dhcpserver_addr /var/lib/lucie/nfsroot/xen-installer &");
    	}
    }
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Vm_boot - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Vm_boot;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Vm_boot, created by h2xs. It looks like the
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
