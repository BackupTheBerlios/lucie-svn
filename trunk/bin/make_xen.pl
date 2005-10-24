#!/usr/bin/perl

use 5.008004;
use strict;
use warnings;
use Carp;

use Vmlucie::Xen_static;
use Vmlucie::Make_xen_cfg;
use Vmlucie::Make_xen_disk;
use Vmlucie::Execute_xen;

# Xen�Υ���ե����ե��������������ǥ��������᡼������������θ�Xen��ư����
# lucie�ǥ��󥹥ȡ��봰λ�塢xen���ö����åȥ����󤷡��Ƶ�ư����
# ������vm��̾�������۷׻�����MAC���ɥ쥹������Υ�������HDD�Υ�������ip���ɥ쥹��netmask��gateway��nfsroot�����С��Υ��ɥ쥹��nfsroot�Υѥ�
my $vmname = shift;
my $memory = shift;
my $mac = shift;
my $hdd = shift;
my $ip = shift;
my $netmask = shift;
my $gateway = shift;
my $nfsaddr = shift;
my $nfspath = shift;


system("rm -f $Vmlucie::Xen_static::VM_CFG_DIR/$vmname*");
system("rm -f $Vmlucie::Xen_static::VM_DISK_DIR/$vmname*");

make_nfsroot_cfg($vmname, $memory, $mac, $ip, $netmask, $gateway, $nfsaddr, $nfspath);

make_exec_cfg($vmname, $memory, $mac);

make_xen_disk($vmname, $hdd);

execute_xen($vmname);
