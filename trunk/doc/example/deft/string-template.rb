template( 'example/string' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = '���ʤ��Τ�̾�������Ϥ��Ƥ�������'
  template.extended_description_ja = <<-DESCRIPTION_JA
  string �ƥ�ץ졼�ȤǤ�Ǥ�դ�ʸ��������ϤǤ��ޤ���
  DESCRIPTION_JA
end

question( 'example/string' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = 'example/display_your__name'
end
