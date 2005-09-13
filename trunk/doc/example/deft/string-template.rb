template( 'example/string' ) do |template|
  template.template_type = 'string'
  template.short_description_ja = 'あなたのお名前を入力してください'
  template.extended_description_ja = <<-DESCRIPTION_JA
  string テンプレートでは任意の文字列を入力できます。
  DESCRIPTION_JA
end

question( 'example/string' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = 'example/display_your__name'
end
