require 'deft'

template( 'example/password' ) do |template|
  template.template_type = 'password'
  template.short_description_ja = 'root �ѥ���ɤ����Ϥ��Ƥ�������'
  template.extended_description_ja = <<-DESCRIPTION_JA
  password �ƥ�ץ졼�ȤǤϥѥ���ɤʤɤε�̩��������ϤǤ��ޤ���
  string �ƥ�ץ졼�ȤȤΰ㤤�ϡ��������Ƥ��������Хå�����ʤ����Ǥ���
  DESCRIPTION_JA
end

question( 'example/password' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = 'example/root_login'
end
