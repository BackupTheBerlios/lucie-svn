package Node_list;
#管理者が用意した、vmを構築するマシン、構築するマシンのMACアドレス、そのIPがかかれたファイルを見て、そのリストを返す

use 5.008004;
use strict;
use warnings;
use Carp;

use Global;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(ret_list
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(ret_list
	
);

our $VERSION = '0.01';


# 引数はvmの種類とノード数
# 返り値は構築する仮想計算機のリスト
sub ret_list{
    my $vm = shift;
    my $node = shift;
    my $vm_ip_cfg;
    my $i;
    my $line;
    my @list;


    if ($vm eq "vmware"){
	$vm_ip_cfg = $Global::vmware_ip_list;
    }elsif ($vm eq "xen"){
	$vm_ip_cfg = $Global::xen_ip_list;
    }

    open(RFILE, $vm_ip_cfg) or die "unabled to open $vm_ip_cfg\n";
    open(WFILE, ">$Global::nodelist") or die "unabled to make $Global::nodelist\n";

    print WFILE "$vm\n";

    for ($i=0; $i<$node; $i++){
	$line = <RFILE>;
	
	if ($line =~/^(\S+)\s+(\S+)\s+(\S+)/){
	    my @group = ($1, $2, $3);
	    @list = (@list, @group);
	    print WFILE "@group\n";
	}
    }
    
    return @list;

    close(RFILE);
    close(WFILE);
}
1;
__END__
