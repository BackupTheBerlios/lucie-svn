template( 'example/select' ) do |template|
  template.template_type = 'select'
  template.choices = ['blue', 'white', 'yellow', 'red'] # ���������
  template.short_description_ja = '���ʤ��ι����ʿ��� ?'
  template.extended_description_ja = <<-DESCRIPTION_JA
  select �ƥ�ץ졼�ȤǤϥ桼�����������󼨤��������椫���Ĥ����Ф��뤳�Ȥ��Ǥ��ޤ���

  ���ʤ��ι����ʿ��ϲ��Ǥ�����
  DESCRIPTION_JA
end

question( 'example/select' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = { 'blue' => 'example/blue',    # �桼�����Ϥ˱�����������򿶤�ʬ��
                             'white' => 'example/white', 
                             'yellow' => 'example/yellow', 
                             'red' => 'example/red' }
end
