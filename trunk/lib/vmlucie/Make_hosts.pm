package Make_hosts;
# /etc/hostsの形式に沿ったファイルを作成する
# このファイルはlucie-setupを行うマシンのホストファイルに追加し、またインストールするノードにもこのファイルを設置する


use 5.008004;
use strict;
use warnings;
use Carp;

use Global;
use Lucie_cfg;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(make_hosts
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(make_hosts
	
);

sub make_hosts{
    my $vm = shift;
    my @node_list = @_;
    my $i;
    open(FILE, ">$Global::tmpdir/hosts") or die "unabled to make $Global::tmpdir/hosts";
    my $node = ($#node_list + 1)/3;
    for ($i = 0; $i<$node; $i++){
	my $host = shift @node_list;
	my $mac = shift @node_list;
	my $ip = shift @node_list;
	
	print FILE "$ip\t$vm$i.$Lucie_cfg::dhcp_server_domain_name $vm$i\n";
    }
    
}

1;
__END__
