#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie'

include Lucie

template( 'lucie-vmsetup/hello' ) do |template|
  template.template_type = Template::NOTE
  template.description = (<<-DESCRIPTION)
Hello!
Welcome to Lucie VM setup wizard.
  DESCRIPTION
  template.description_ja = (<<-DESCRIPTION_JA)
����ɂ���
Lucie VM �̃Z�b�g�A�b�v�E�B�U�[�h�ւ悤����
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/num-nodes' ) do |template|
  template.template_type = Template::STRING
  template.description_ja = (<<-DESCRIPTION_JA)
VM �m�[�h�䐔�̑I���ł�
�g�p������ VM �̑䐔�����Ă�������
  DESCRIPTION_JA
end.register

template( 'lucie-vmsetup/use-network' ) do |template|
  template.template_type = Template::BOOLEAN
  template.default = 'no'
  template.description_ja = (<<-DESCRIPTION_JA)
�m�[�h�̃l�b�g���[�N
�m�[�h�̓l�b�g���[�N�ɂȂ���܂����H
  DESCRIPTION_JA
end.register

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
