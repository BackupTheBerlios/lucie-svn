#!/usr/bin/ruby1.8
#
# $Id$
#
# install-packages ������ץȤ����򤵤줿���եȥ������ѥå������򥤥�
# ���ȡ��뤷�ޤ���/etc/lucie/package �ǥ��쥯�ȥ�ʲ��Τ��٤Ƥ�����ե�
# ������ɤ߹��ߤޤ���ʸˡ�����˥���ץ�Ǥ���
#
#   taskinst( %w(german) )
#  
#   aptitude do |aptitude|
#     aptitude.list = %w(adduser netstd ae less passwd)
#   end
# 
#   remove( %w(gpm xdm) )
#  
#   dselect_upgrade do |dselect_upgrade|
#     dselect_upgrade.list << { :package => 'ddd',  :action => 'install' }
#     dselect_upgrade.list << { :package => 'a2ps', :action => 'install' }
#   end
#
# �����Ȥϥϥå��嵭�� (#) ��������ޤǤǤ������٤ƤΥ��ޥ�ɤ� Ruby 
# �δؿ��ƤӽФ������ȤʤäƤ��ꡢ�����֥�å��ʤɤΰ�������ޤ���
# ���ޥ��̾�� apt-get �Υ��ޥ�ɤ˶ᤤ�Ǥ����ʲ������ݡ��Ȥ��Ƥ��륳
# �ޥ�ɤΰ����Ǥ���
#
# hold: 
#     �ѥå������ΥС���������ꤷ�ޤ����ۡ���ɤ��줿�ѥå������� 
#     dpkg �ˤ�����Ǥ��ʤ��ʤ�ޤ����Ĥޤꡢ���åץ��졼�ɤ����
#     ���ʤ�ޤ���
#
# install:
#     �ꥹ�Ȥǻ��ꤷ�����٤ƤΥѥå������򥤥󥹥ȡ��뤷�ޤ����ѥå���
#     ��̾�θ�˥ϥ��ե��դ����Ƥ������ (����ϴޤޤʤ�)�����Υѥ�
#     �������ϥ��󥹥ȡ��뤵�줺�������ޤ���
#
# remove:
#     �����ǻ��ꤷ�����٤ƤΥѥå������������ޤ����ѥå������򥤥�
#     �ȡ��뤷�������ˤ� '+' ��ѥå�����̾��³���Ƶ��Ҥ��ޤ���
#
# taskinst:
#     �����ǻ��ꤷ���������˴ޤޤ�뤹�٤ƤΥѥå������� tasksel(1) ��
#     �Ѥ��ƥ��󥹥ȡ��뤹�롣�������Υ��󥹥ȡ���ˤ� aptitude ���Ѥ�
#     �뤳�Ȥ�Ǥ��롣
#
# aptitude:
#     ���٤ƤΥѥå������� aptitude ���ޥ�ɤǥ��󥹥ȡ��뤹�롣
#
# aptitude-r:
#     aptitude ���ޥ�ɤ�Ʊ�ͤ�����aptitude �� --with-recommends ����
#     ������դ��Ǽ¹Ԥ��롣
#
# dselect-upgrade:
#     �ѥå���������������Ԥ��ޤ���"dpkg --get-selection" �ν��Ϥ�
#     Ʊ�ͤˡ�:package �ˤϥѥå�����̾��:action �ˤϼ¹Ԥ�������������
#     �����ꤷ�ޤ���
#
# ���٤Ƥΰ�¸�ط��ϲ�褵��ޤ������ե��å����� '-' ���դ����ѥå���
# ��̾�ϥ��󥹥ȡ��뤵�������˺������ޤ����ѥå������ν���ϰ�̣
# ������ޤ���
#
# �֥�å���� preloadrm ����ꤷ����硢�ѥå������Υ��󥹥ȡ������� 
# wget(1) ���Ѥ����ե�����Υ�������ɤ��Ԥ��ޤ���file: �ǻ��ꤵ��
# �� URL ���Ѥ��뤳�Ȥˤ�äơ����ꤵ�줿�ե������ Lucie �� ROOT �ե�
# ���륷���ƥ�⤷���ϥ��󥿡��ͥåȾ夫���������ɥǥ��쥯�ȥ�إ�
# �ԡ�����ޤ�����Ȥ��ơ�realplayer �ѥå������ϥ��󥹥ȡ���Τ����
# ���������֥ե������ɬ�פȤ��뤿�ᡢ���������֥ե����뤬 /root �إ�
# ������ɤ���ޤ������󥹥ȡ���θ夳�Υե�����Ϻ������ޤ����ե�
# ��������������ʤ����ˤϡ������ preload ����Ѥ��Ƥ���������
#
#--
# TODO: utils/chkdebnames�������å����ץ����ΰܿ�
# TODO: preload, preloadrm �Τ����Ȥ������ݡ���
# TODO: ���줾��Υ��ޥ�ɤε�����
#++
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2
#

require 'English'
require 'install-packages/abstract-command'
require 'install-packages/app'
require 'install-packages/command/aptitude'
require 'install-packages/command/aptitude-r'
require 'install-packages/command/clean'
require 'install-packages/command/dselect-upgrade'
require 'install-packages/command/hold'
require 'install-packages/command/install'
require 'install-packages/command/remove'
require 'install-packages/command/taskinst'
require 'install-packages/command/taskrm'
require 'install-packages/options'
require 'uri'

if __FILE__ == $PROGRAM_NAME
  InstallPackages::App.instance.main
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
