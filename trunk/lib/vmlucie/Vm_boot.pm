package Vm_boot;
#���۷׻������ۤ���ץ�����¹Ԥ�����

use 5.008004;
use strict;
use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(vm_boot
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(vm_boot
	
);


# ���۷׻�����Ω���夲��ۥ��ȥޥ�����Ф��ơ�Ω���夲��褦��̿���Ф�
# ���ߤ�ssh or rsh����ѡ�remote_shell����ʬ��񤭴�������ˤ���ѹ���ǽ
# ������vm�μ��ࡢ�׻����ο���memory�����̡�hdd�����̡��Ρ��ɥꥹ��
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
	    system("$remote_shell $host /home/ikuhei/xen_exec/make_xen.pl xen$i $memory $mac $hdd $ip $Lucie_cfg::dhcp_server_subnet $Lucie_cfg::dhcp_server_gateway $Lucie_cfg::dhcp_server_address /var/lib/lucie/nfsroot/xen-installer &");
    	}
    }
}

1;
__END__
