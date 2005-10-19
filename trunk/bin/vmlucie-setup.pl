#!/usr/bin/perl


use strict;
use warnings;
use Carp;

use Global;
use File::Copy;

use Read_client_cfg;
use Post_luciesetup;


#client���������Ƥ����ե�������ɤ߹��ߡ������Ԥ���
#�����Ϥʤ�
read_client_cfg();
my $vm = ret_vm();
my @metapackage = ret_metapackage();


#lucie������ե�����򥳥ԡ����Ƥ���
my $installer = "-installer";
substr($installer, 0, 0) = $vm;
copy("$Global::tmpdir/PKG", "$Global::pkgdir/$installer/package/PKG");

copy("$Global::tmpdir/resource.rb", "$Global::resource_dir/resource.rb");

#hosts�ե�����������ޥ����hosts�ե������installer�ʲ����֤�
copy("$Global::tmpdir/hosts.tmp", "/etc/hosts");
copy("$Global::tmpdir/hosts", "/etc/lucie/$installer/files/etc/hosts/DEFAULT");

#lucie�Υ��åȥ��å�
#TODO: ���󥹥ȡ��顼�ΤȤ���Ͻ񤭴�����
system "PATH=\$PATH:/usr/local/sbin:/usr/sbin/:/sbin lucie-setup -i $installer";
my $pkg_num = $#metapackage + 1;
my $i;
for ($i = 0; $i < $pkg_num; $i++){
    my $meta = shift @metapackage;
    system "PATH=\$PATH:/usr/local/sbin:/usr/sbin/:/sbin lucie-setup -i $installer -a $meta";
}

#�����
#������vm�μ���
post_luciesetup($vm);
