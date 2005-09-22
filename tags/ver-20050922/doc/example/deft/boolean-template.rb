template( 'example/boolean' ) do |template|
  template.template_type = 'boolean'
  template.default = 'true'
  template.short_description_ja = '���ʤ��������Ǥ��� ?'
  template.extended_description_ja = <<-DESCRIPTION_JA
   boolean �ƥ�ץ졼�ȤǤ� YES/NO �����μ����ɽ���Ǥ��ޤ���
  DESCRIPTION_JA
end

question( 'example/boolean' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = { 'true'  => 'example/male',
                             'false' => 'example/female' }
end
