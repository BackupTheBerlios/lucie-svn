#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome ��å�����

template( 'lucie-client/default/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-default setup wizard.'
  template.short_description_ja = 'lmp-default ���åȥ��åץ��������ɤؤ褦����'
  template.extended_description = <<-DESCRIPTION
  Click OK
  DESCRIPTION
end

question( 'lucie-client/default/hello' => proc do 
            timezones = Dir.chdir( '/usr/share/zoneinfo' ) do 
              (Dir.glob('*')+Dir.glob('*/*') - ['localtime', 'zone.tab']).sort.join(', ')
            end
            subst 'lucie-client/default/timezone', 'timezones', timezones
            'lucie-client/default/timezone' 
          end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- Timezone ������

template( 'lucie-client/default/timezone' ) do |template|
  template.template_type = 'select'
  template.choices = '${timezones}'
  template.default = 'Asia/Tokyo'
  template.short_description = 'Configure timezone'
  template.short_description_ja = '�����ॾ���������'
  template.extended_description = <<-DESCRIPTION
  Please select timezone.
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  �����ॾ���������Ǥ�������
  DESCRIPTION_JA
end

question( 'lucie-client/default/timezone' => 'lucie-client/default/utc' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- UTC ������

template( 'lucie-client/default/utc' ) do |template|
  template.template_type = 'boolean'
  template.short_description = 'Configure UTC'
  template.short_description_ja = 'UTC ������'
  template.extended_description = <<-DESCRIPTION
  Does your hardware clock set to UTC?
  DESCRIPTION
  template.extended_description_ja = <<-DESCRIPTION_JA
  �ϡ��ɥ���������å��� UTC �˥��åȤ���Ƥ��ޤ�����
  DESCRIPTION_JA
end

question( 'lucie-client/default/utc' )
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
