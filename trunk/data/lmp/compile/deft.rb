#
# $Id$
#
# ����ѥ���Ķ� (����ѥ��顢�ǥХå����Ƽ�ġ��롢�ɥ��������) ��
# ���åȥ��åפ��뤿��� Lucie �᥿�ѥå�������
#
#--
# TODO: ����ѥ���ΥС������������ǽ�ˤ���
# TODO: /etc/alternatives �������ưŪ�˹Ԥ�
#++
#
# Author::   Yasuhito TAKAMIYA (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome ��å�����

template( 'lucie-client/compile/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-compile setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will setup packages for developing software.
  DESCRIPTION
end

question( 'lucie-client/compile/hello' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
