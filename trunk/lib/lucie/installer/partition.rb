#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

sh( %{setup_harddisks -f /etc/lucie/partition -d -X > #{$format_log} 2>&1}, $sh_option )
# TODO: $diskvar ����������ʤ��ä����Υ��顼����
# TODO: setup_harddisks �κƼ���

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: