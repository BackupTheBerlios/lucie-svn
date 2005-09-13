template( 'example/boolean' ) do |template|
  template.template_type = 'boolean'
  template.default = 'true'
  template.short_description_ja = 'あなたは男性ですか ?'
  template.extended_description_ja = <<-DESCRIPTION_JA
   boolean テンプレートでは YES/NO 形式の質問を表示できます。
  DESCRIPTION_JA
end

question( 'example/boolean' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = { 'true'  => 'example/male',
                             'false' => 'example/female' }
end
