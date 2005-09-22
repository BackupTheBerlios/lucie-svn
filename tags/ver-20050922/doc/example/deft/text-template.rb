template( 'example/text' ) do |template|
  template.template_type = 'text'
  template.short_description_ja = '����ˤ��� deft'
  template.extended_description_ja = <<-DESCRIPTION_JA
  text �ƥ�ץ졼�ȤǤϥ桼���ˤʤ�餫�ξ����ɽ�����뤳�Ȥ��Ǥ��ޤ���
  DESCRIPTION_JA
end

question( 'example/text' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = 'example/bye'
end
