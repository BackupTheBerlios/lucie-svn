require 'deft'

template( 'example/password' ) do |template|
  template.template_type = 'password'
  template.short_description_ja = 'root パスワードを入力してください'
  template.extended_description_ja = <<-DESCRIPTION_JA
  password テンプレートではパスワードなどの機密情報を入力できます。
  string テンプレートとの違いは、入力内容がエコーバックされない点です。
  DESCRIPTION_JA
end

question( 'example/password' ) do |question|
  question.priority = Deft::Question::PRIORITY_MEDIUM
  question.first_question = true
  question.next_question = 'example/root_login'
end
