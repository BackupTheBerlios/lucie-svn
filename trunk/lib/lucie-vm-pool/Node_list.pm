package Vmlucie::Node_list;

use 5.008004;
use strict;
use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);


our @EXPORT = qw(ret_list);

our $VERSION = '0.01';

# 引数はノード数と仮想計算機リストのパス
# 返り値は構築する仮想計算機のリスト
sub ret_list{
    my $argc = $#_;
    if ($argc != 1){
	die "引数にはノード数とノードリストのパスを指定してください\n";
    }
    my $node = shift;
    my $list_path = shift;
    my $i;
    my $line;
    my @list;


    open(FILE, "$list_path") or die "unabled to open $list_path\n";


    for ($i=0; $i<$node; $i++){
	$line = <FILE>;
        
        if ($line =~/^(\S+)\s+(\S+)\s+(\S+)/){
            my @group = ($1, $2, $3);
            @list = (@list, @group);
        }
    }
    
    close(FILE);
    return @list;
}
1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Node_list - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Node_list;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Node_list, created by h2xs. It looks like the
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
