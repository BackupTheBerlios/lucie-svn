package Vmlucie::Read_client_cfg;
##�桼�������������Ƥ�������ե�������ɤ߹��ߡ��ͤ��֤�

use 5.008004;
use strict;
use warnings;
use Carp;


require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(read_client_cfg ret_nodenum ret_memory ret_hdd ret_vm ret_package ret_metapackage
);

our $VERSION = '0.01';

my $nodenum;
my $vm;
my $memory;
my $hdd;
my @package;
my @metapackage;

sub read_client_cfg{
    my $filepath = shift;
    my $line;
    

    open(FILE, $filepath) or die "unabled open $filepath\n";

    for $line (<FILE>){
	if ($line =~/^nodenum\s+(\w+)/){
	    $nodenum = $1;
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

sub ret_nodenum{
    return $nodenum;
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
