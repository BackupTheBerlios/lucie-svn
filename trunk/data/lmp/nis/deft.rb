#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'

include Deft

# -------------------------

template( 'lucie-client/nis/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-nis setup wizard'
  template.short_description_ja = 'NIS ���^�p�b�P�[�W�̐ݒ�E�B�U�[�h�ւ悤����'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate NIS (Network Information Service) configuration.
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ݒ�E�B�U�[�h�� NIS (Network Information Service) �̐ݒ���s���܂��B
  DESCRIPTION_JA
end

question( 'lucie-client/nis/hello' => 'lucie-client/nis/server' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# -------------------------

template( 'lucie-client/nis/server' ) do |template|
  template.template_type = 'string'
  template.short_description = 'Configure NIS Server'
  template.short_description_ja = 'NIS �T�[�o�̐ݒ�'
  template.extended_description = <<-DESCRIPTION
  Please input your nis server address.

  ( [Ex] nis-server.example.com )
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  NIS �T�[�o�̃A�h���X����͂��ĉ������B

  ( [��] nis-server.example.com )
  DESCRIPTION_JA
end

question( 'lucie-client/nis/server' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: