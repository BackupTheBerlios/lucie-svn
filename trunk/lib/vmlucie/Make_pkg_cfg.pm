package Make_pkg_cfg;

use 5.008004;
use strict;
use warnings;
use Carp;

use Global;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Make_pkg_cfg ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(make_pkg_cfg
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(make_pkg_cfg
	
);

our $VERSION = '0.01';


# lucieでインストールするパッケージを設定するファイルを作成する
#引数はパッケージ名
sub make_pkg_cfg{
    my $pkg_path2 = shift;
    my @package = @_;
    #print "package = @package\n";

    #my $pkg_path = $Global::pkgdir2;
    #substr($pkg_path, 0, 0) = "/$pkg_path2/";
    #substr($pkg_path, 0, 0) = $Global::pkgdir1;

    my $pkg_path = "$Global::tmpdir/PKG";
#    print "pkg_path = $pkg_path\n";

    open(FILE,">$pkg_path") or die "unabled to make $pkg_path\n";
    
    print FILE "aptitude( %w(lilo initrd-tools ntpdate @package))";
    
    close(FILE);
}
    

1;
__END__
