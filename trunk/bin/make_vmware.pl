#!/usr/bin/perl

use 5.008004;
use strict;
use warnings;
use Carp;

use Vmlucie::Make_vmware_cfg;
use Vmlucie::Make_vmware_disk;
use Vmlucie::Execute_vmware;

# VMware�Υ���ե����ե��������������ǥ��������᡼������������θ�VMware��ư����
# ������vm��̾�������۷׻�����MAC���ɥ쥹������Υ�������HDD�Υ�����
my $vmname = shift;
my $mac = shift;
my $memory = shift;
my $hdd = shift;

make_vmware_cfg($vmname, $memory, $mac);

make_vmware_disk($vmname, $hdd);

execute_vmware($vmname);
