package Vmlucie::Post_luciesetup;
# lucieセットアップ後の後処理を行う


use 5.008004;
use strict;
use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Vmlucie::Post_luciesetup ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(post_luciesetup
	
);

our $VERSION = '0.01';


# 引数は仮想計算機の種類
sub post_luciesetup{
    my $vm = shift;
    my $installer="-installer";
    substr($installer, 0 ,0) = $vm;

    if ($vm eq "vmware"){
	#インストール終了後自動的にrebootさせる
	copy("/etc/lucie/patch/lucieend.rb_for_vmware", "/var/lib/lucie/nfsroot/$installer/usr/lib/ruby/1.8/lucie/installer/lucieend.rb");
    }elsif ($vm eq "xen"){
	#パーティションを切る事ができないためコメントアウト
	copy("/etc/lucie/patch/rcS_lucie_for_xen", "/var/lib/lucie/nfsroot/$installer/sbin/rcS_lucie");
	#フォーマットするために必要なファイルをコピーする
	copy("/etc/lucie/patch/fstab_for_xen", "/var/lib/lucie/nfsroot/$installer/var/tmp/fstab");
	#上記のファイルを実行中に適当な場所に置くためのスクリプトを追加
	copy("/etc/lucie/patch/mountdisks.rb_for_xen","/var/lib/lucie/nfsroot/$installer/usr/lib/ruby/1.8/lucie/installer/mountdisks.rb");
	#lucie-setup終了後自動的にshutdownさせる
	copy("/etc/lucie/patch/lucieend.rb_for_xen", "/var/lib/lucie/nfsroot/$installer/usr/lib/ruby/1.8/lucie/installer/lucieend.rb");
    }
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Vmlucie::Post_luciesetup - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Vmlucie::Post_luciesetup;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Vmlucie::Post_luciesetup, created by h2xs. It looks like the
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
