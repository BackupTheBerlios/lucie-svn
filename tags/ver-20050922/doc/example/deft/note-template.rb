template( 'example/note' ) do |template|
  template.template_type = 'note'
  template.short_description_ja = '重要な情報'
  template.extended_description_ja = <<-DESCRIPTION_JA
  note テンプレートではユーザになんらかの重要な情報を表示することができます。
  DESCRIPTION_JA
end

question( 'example/note' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = 'example/bye'
end
