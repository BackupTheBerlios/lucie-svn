
require 'deft'
include Deft

# ------------------------- Welcome message

template( 'lucie-client/mail/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-mail setup wizard.'
  template.extended_description = <<-DESCRIPTION
  This metapackage will generate Lucie configuration of mailx and postfix.
  DESCRIPTION
  template.short_description_ja = 'lmp- ���åȥ��åץ��������ɤؤ褦����'
  template.extended_description_ja = <<-DESCRIPTION_JA
  ���Υ᥿�ѥå������� mailx/postfix ������� Lucie �����ФعԤ��ޤ��� 
  DESCRIPTION_JA
end

question( 'lucie-client/mail/hello') do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
