template( 'example/note' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '���פʾ���'
  template.extended_description_ja = <<-DESCRIPTION_JA
  note �ƥ�ץ졼�ȤǤϥ桼���ˤʤ�餫�ν��פʾ����ɽ�����뤳�Ȥ��Ǥ��ޤ���
  DESCRIPTION_JA
end

question( 'example/note' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = 'example/bye'
end
