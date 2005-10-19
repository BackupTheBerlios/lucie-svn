package Read_client_cfg;
##ユーザーから送られてきた設定ファイルを読み込み、値を返す

use 5.008004;
use strict;
use warnings;
use Carp;

use Global;

require Exporter;

our @ISA = qw(Exporter);


our %EXPORT_TAGS = ( 'all' => [ qw(read_client_cfg ret_node ret_memory ret_hdd ret_vm ret_package
ret_metapackage	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(read_client_cfg ret_node ret_memory ret_hdd ret_vm ret_package ret_metapackage
	
);


my $node;
my $vm;
my $memory;
my $hdd;
my @package;
my @metapackage;

sub read_client_cfg{
    my $line;

    open(FILE, $Global::client_cfg) or die "unabled open $Global::client_cfg\n";

    for $line (<FILE>){
	if ($line =~/^node\s+(\w+)/){
	    $node = $1;
	}elsif ($line =~/^vm\s+(\w+)/){
	    $vm = $1;
	    $Global::vm = $1;
	}elsif ($line =~/^memory\s+(\w+)/){
	    $memory = $1;
	}elsif ($line =~/^hdd\s+(\w+)/){
	    $hdd = $1;
	}elsif ($line =~/^package\s+(.*)/){
	    my $loop = $1;
	    while ($loop =~/^(\S+)\s+(.+)/){
		@package = (@package, $1);
		$loop = $2;
	    }
	    if ($loop =~/^(\S+)/){
		@package = (@package, $1);
	    }
	}elsif ($line =~/^meta\s+(.*)/){
	    my $loop = $1;
	    while ($loop =~/^(\S+)\s+(.+)/){
		@metapackage = (@metapackage, $1);
		$loop = $2;
	    }
	    if ($loop =~/^(\S+)/){
		@metapackage = (@metapackage, $1);
	    }
	}
    }
  
    close(FILE);
}

sub ret_node{
    return $node;
}

sub ret_vm{
    return $vm;
}

sub ret_memory{
    return $memory;
}

sub ret_hdd{
    return $hdd;
}

sub ret_package{
    return @package;
}

sub ret_metapackage{
    return @metapackage;
}
1;
__END__
