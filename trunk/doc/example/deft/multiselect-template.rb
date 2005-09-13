template( 'example/multiselect' ) do |template|
  template.template_type = 'multiselect'
  template.choices = ['blue', 'white', 'yellow', 'red'] # 選択肢を指定
  template.short_description_ja = 'あなたの好きな色は ? (複数回答可)'
  template.extended_description_ja = <<-DESCRIPTION_JA
  multiselect テンプレートではユーザに選択肢を提示し、その中から複数を選ばせることができます。
  DESCRIPTION_JA
end

question( 'example/multiselect' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true 
  question.next_question = proc do |user_nput| # ユーザ入力に応じて遷移先を振り分け
    # 変数 user_input に選択内容 ('blue, yellow' などの文字列) が入る
    'example/next' # 次の遷移先
  end
end
