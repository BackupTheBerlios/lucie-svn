package Vm_boot;
#仮想計算機を構築するプログラムを実行させる

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


# 仮想計算機を立ち上げるホストマシンに対して、立ち上げるように命令を出す
# 現在はssh or rshを使用、remote_shellの部分を書き換える事により変更可能
# 引数はvmの種類、計算機の数、memoryの容量、hddの容量、ノードリスト
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
