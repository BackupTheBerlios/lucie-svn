template( 'example/select' ) do |template|
  template.template_type = 'select'
  template.choices = ['blue', 'white', 'yellow', 'red'] # 選択肢を指定
  template.short_description_ja = 'あなたの好きな色は ?'
  template.extended_description_ja = <<-DESCRIPTION_JA
  select テンプレートではユーザに選択肢を提示し、その中から一つを選ばせることができます。

  あなたの好きな色は何ですか？
  DESCRIPTION_JA
end

question( 'example/select' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = { 'blue' => 'example/blue',    # ユーザ入力に応じて遷移先を振り分け
                             'white' => 'example/white', 
                             'yellow' => 'example/yellow', 
                             'red' => 'example/red' }
end
