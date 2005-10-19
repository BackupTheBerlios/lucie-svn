package Post_luciesetup;
# lucieセットアップ後の後処理を行う

use 5.008004;
use strict;
use warnings;
use Carp;

use File::Copy;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Post_luciesetup ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(post_luciesetup
	
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
