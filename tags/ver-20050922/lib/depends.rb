# =libdepends �ᥤ��ե�����
#
# libdepends �Υᥤ��ե����롣libdepends ����Ѥ�����ˤϤ��Υե���
# ���ʲ��Τ褦�� +require+ ���뤳�ȡ�
#
#  require 'depends'
#
# $Id$
#
# Author:: Yasuhito TAKAMIYA <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $Revision$
# License::  GPL2
#
#--
# TODO:
# * Support RPM and other formats.
#++

module Depends
  # �С�������ֹ�
  VERSION = '0.0.2'.freeze
  # ���ѤǤ���ѥå���������
  STATUS  = '/var/lib/dpkg/status'.freeze
end

require 'depends/cache'
require 'depends/dependency'
require 'depends/package'
require 'depends/pool'

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
