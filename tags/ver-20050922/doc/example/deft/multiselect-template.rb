template( 'example/multiselect' ) do |template|
  template.template_type = 'multiselect'
  template.choices = ['blue', 'white', 'yellow', 'red'] # ���������
  template.short_description_ja = '���ʤ��ι����ʿ��� ? (ʣ��������)'
  template.extended_description_ja = <<-DESCRIPTION_JA
  multiselect �ƥ�ץ졼�ȤǤϥ桼�����������󼨤��������椫��ʣ�������Ф��뤳�Ȥ��Ǥ��ޤ���
  DESCRIPTION_JA
end

question( 'example/multiselect' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true 
  question.next_question = proc do |user_nput| # �桼�����Ϥ˱�����������򿶤�ʬ��
    # �ѿ� user_input ���������� ('blue, yellow' �ʤɤ�ʸ����) ������
    'example/next' # ����������
  end
end
