template( 'example/text' ) do |template|
  template.template_type = 'text'
  template.short_description_ja = 'こんにちは deft'
  template.extended_description_ja = <<-DESCRIPTION_JA
  text テンプレートではユーザになんらかの情報を表示することができます。
  DESCRIPTION_JA
end

question( 'example/text' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = 'example/bye'
end
