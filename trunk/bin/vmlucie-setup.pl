#!/usr/bin/perl


use strict;
use warnings;
use Carp;

use Global;
use File::Copy;

use Read_client_cfg;
use Post_luciesetup;


#clientから送られてきたファイルを読み込み、設定を行う。
#引数はなし
read_client_cfg();
my $vm = ret_vm();
my @metapackage = ret_metapackage();


#lucieの設定ファイルをコピーしてくる
my $installer = "-installer";
substr($installer, 0, 0) = $vm;
copy("$Global::tmpdir/PKG", "$Global::pkgdir/$installer/package/PKG");

copy("$Global::tmpdir/resource.rb", "$Global::resource_dir/resource.rb");

#hostsファイルをローカルマシンのhostsファイルとinstaller以下に置く
copy("$Global::tmpdir/hosts.tmp", "/etc/hosts");
copy("$Global::tmpdir/hosts", "/etc/lucie/$installer/files/etc/hosts/DEFAULT");

#lucieのセットアップ
#TODO: インストーラーのところは書き換える
system "PATH=\$PATH:/usr/local/sbin:/usr/sbin/:/sbin lucie-setup -i $installer";
my $pkg_num = $#metapackage + 1;
my $i;
for ($i = 0; $i < $pkg_num; $i++){
    my $meta = shift @metapackage;
    system "PATH=\$PATH:/usr/local/sbin:/usr/sbin/:/sbin lucie-setup -i $installer -a $meta";
}

#後処理
#引数はvmの種類
post_luciesetup($vm);
