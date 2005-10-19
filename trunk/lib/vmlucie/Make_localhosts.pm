package Make_localhosts;
## lucie-setup��¹Ԥ���ޥ����/etc/hosts�ե�������֤������뤿����֤��������Ȥ�hosts�ե�������������

use 5.008004;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw(make_localhosts
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(make_localhosts
	
);

sub make_localhosts{

    my $line;

    open(RFILE, "/etc/hosts") or die "unabled to open /etc/hosts\n";
    open(WFILE, ">$Global::tmpdir/hosts.tmp") or die "unabled to make $Global::tmpdir/host.tmp\n";
    
    for $line (<RFILE>){
	if ($line =~/^\#\#add hostname for lucie-setup/){
	    last;
	}
	print WFILE $line;
    }
    print WFILE "##add hostname for lucie-setup##\n";
    close(RFILE);
    close(WFILE);

    system "cat $Global::tmpdir/hosts >> $Global::tmpdir/hosts.tmp";

}
1;
__END__
