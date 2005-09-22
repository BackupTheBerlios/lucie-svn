#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'deft/string'
require 'deft/time-stamp'

module Deft
  update(%q$Id$)

  module Exception
    class InvalidAttributeException < ::Exception; end
    class RequiredAttributeException < ::Exception; end
  end

  # == テンプレートの基礎
  #
  # Debconf には、「テンプレート」と「変数」と呼ばれる概念があります。
  # 画面に表示される各質問画面は質問内容や質問形式の定義であるテンプレー
  # トをもとにして生成されます。ユーザが Debconf を通じて入力した内容
  # は変数に代入されます。Debconf を用いた質問ダイアログの開発では、ま
  # ずユーザに表示したい質問項目をリストアップし、各質問項目に対応する
  # テンプレートと変数を定義する必要があります。
  #
  # Debconf の仕様についてより詳しくは {Configuration Management Protocol Version 2}[http://www.debian.org/doc/packaging-manuals/debconf_specification.html] 
  # を参照してください。
  # 
  # === テンプレート
  # 
  # テンプレートはユーザに表示する質問項目の雛形を指定するものです。テ
  # ンプレートの主な属性には名前、型、デフォルト値、説明があります
  #
  #   Template: 名前
  #   Type: 型
  #   Default: デフォルト値
  #   Description: 短かい説明
  #    長い説明
  #
  # 型 (Type: フィールド) は質問の種類を指定します。質問の種類には以下
  # があります。
  #
  # * string: 文字列を入力させる質問
  # * boolean: true か false を選ばせる質問
  # * select: 複数項目から一つを選ばせる質問
  # * multiselect: 複数項目から複数を選ばせる質問
  # * text: ユーザへ情報を表示する
  # * note: ユーザへ情報を表示しメールを送る
  # * password: パスワードなど機密情報を入力させる質問
  #
  # === 変数
  #
  # 変数はテンプレートから生成されます。テンプレートで指示された型およ
  # び説明を使ってユーザに質問を表示し、その結果を記憶しておくのが変数
  # です。ひとつの変数はひとつの質問画面に対応します。基本的にはテンプ
  # レートと変数は 1 対 1 で対応していますが、ひとつのテンプレートから
  # 複数の変数を作成し、それぞれに異なった値 (ユーザ入力) を保持するこ
  # ともできます。
  #
  # 形式は以下の様になります。
  #
  #   question( 質問名 ) do |question|
  #     question.priority = 優先度
  #     question.first_question = 最初の質問かどうか
  #     question.next_question = 次の質問
  #   end
  #
  # next_question を以下の形式で書くことによって遷移先を直感的にわかり
  # やすくすることもできます。矢印 (=>) がありますがこれは実際にはハッ
  # シュの矢印です。
  #
  #   question( 質問名 => 次の質問 ) do |question|
  #     question.priority = 優先度
  #     question.first_question = 最初の質問かどうか
  #   end
  #
  #
  # 変数の主な属性には以下のものがあります。
  #
  # * priority : 質問の優先度。利用可能な定数は Question クラスに定義されています。
  # * next_question : 次の質問。
  # * first_question : 最初の質問である場合、true を設定します。
  #
  # == メッセージの表示 - text テンプレート
  #
  # text 型のテンプレートを用いることによって、ユーザへメッセージを表
  # 示することができます。
  #
  # http://lucie.sourceforge.net/images/text-template.png
  #
  #   template( 'example/text' ) do |template|
  #     template.template_type = 'text'
  #     template.short_description_ja = 'こんにちは deft'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     text テンプレートではユーザになんらかの情報を表示することができます。
  #     DESCRIPTION_JA
  #   end
  #
  # text 型のテンプレートでは、プロパティ template_type に 'text' を指
  # 定します。
  #
  # このテンプレートを元にした変数 lucie-vmsetup/hello の定義は以下の
  # ようになります。
  #
  #   question( 'example/text' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.next_question = 'example/bye'
  #   end
  #
  # == メッセージを表示し、メールも送る - note テンプレート
  #
  # 設定情報などといったとくに重要なメッセージを表示し、またリマインダ
  # としてメールを送信する場合、note 型のテンプレートを用います。
  #
  # http://lucie.sourceforge.net/images/note-template.png
  #
  # 基本的には text 型のテンプレートと変わらず、型が note になるだけです。
  #
  #   template( 'example/note' ) do |template|
  #     template.template_type = 'note'
  #     template.short_description_ja = '重要な情報'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     note テンプレートではユーザになんらかの重要な情報を表示することができます。
  #     DESCRIPTION_JA
  #   end
  #
  # 変数の定義は text テンプレートと同じです。
  #
  #   question( 'example/note' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.next_question = 'example/bye'
  #   end
  #
  # == YES/NO の質問を表示 - boolean テンプレート
  #
  # 「ハイ」「イイエ」で答えられる種類の質問では、boolean 型のテンプレートを用います。
  #
  # http://lucie.sourceforge.net/images/boolean-template.png
  #
  #   template( 'example/boolean' ) do |template|
  #     template.template_type = 'boolean'
  #     template.default = 'true'
  #     template.short_description_ja = 'あなたは男性ですか ?'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #      boolean テンプレートでは YES/NO 形式の質問を表示できます。
  #     DESCRIPTION_JA
  #   end
  #
  # 変数は以下のようになります。next_question アトリビュートの指定では、
  # true/false を選んだ場合のそれぞれの遷移先をハッシュで指定します。
  #
  #   question( 'example/boolean' ) do |question|
  #     question.priority = Question::PRIORITY_MEDIUM
  #     question.next_question = { 'true'  => 'example/male',
  #                                'false' => 'example/female' }
  #   end
  #
  # == 文字列を入力 - string テンプレート
  #
  # ユーザになんらかの入力をうながす種類の質問では、string 型のテンプ
  # レートを用います。
  #
  # http://lucie.sourceforge.net/images/string-template.png
  #
  #   template( 'example/string' ) do |template|
  #     template.template_type = 'string'
  #     template.short_description_ja = 'あなたのお名前を入力してください'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     string テンプレートでは任意の文字列を入力できます。
  #     DESCRIPTION_JA
  #   end
  #
  # 変数定義では特に特別な点はありません。
  #
  #   question( 'example/string' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.next_question = 'example/display_your__name'
  #   end
  #
  # == 選択肢の中から一つだけ選択 - select テンプレート
  #
  # 選択肢の中からひとつを選ばせる種類の質問では、select 型のテンプレートを用います。
  #
  # http://lucie.sourceforge.net/images/select-template.png
  #
  # テンプレート定義では、choices プロパティで選択肢を指定していること
  # に注目してください。
  #
  #   template( 'example/select' ) do |template|
  #     template.template_type = 'select'
  #     template.choices = ['blue', 'white', 'yellow', 'red'] # 選択肢を指定
  #     template.short_description_ja = 'あなたの好きな色は ?'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     select テンプレートではユーザに選択肢を提示し、その中から一つを選ばせることができます。
  #
  #     あなたの好きな色は何ですか？
  #     DESCRIPTION_JA
  #   end
  #
  # 変数定義では next_question 属性にハッシュを指定することによって、
  # ユーザ入力に応じて遷移先を変化させることができます。
  #
  #   question( 'example/select' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.next_question = { 'blue' => 'example/blue',    # ユーザ入力に応じて遷移先を振り分け
  #                                'white' => 'example/white', 
  #                                'yellow' => 'example/yellow', 
  #                                'red' => 'example/red' }
  #   end
  #
  # == 選択肢の中から複数選択 - multiselect テンプレート
  #
  # 選択肢の中から複数を選ばせる種類の質問では、multiselect 型のテンプレートを用います。
  #
  # http://lucie.sourceforge.net/images/multiselect-template.png
  #
  # テンプレート定義は select テンプレートと同じです
  #
  #   template( 'example/multiselect' ) do |template|
  #     template.template_type = 'multiselect'
  #     template.choices = ['blue', 'white', 'yellow', 'red'] # 選択肢を指定
  #     template.short_description_ja = 'あなたの好きな色は ? (複数回答可)'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     multiselect テンプレートではユーザに選択肢を提示し、その中から複数を選ばせることができます。
  #     DESCRIPTION_JA
  #   end
  #
  # 変数定義では next_question 属性に proc オブジェクトを指定すること
  # によって、ユーザ入力に応じて遷移先を変化させることができます。
  #
  #   question( 'example/multiselect' ) do |question|
  #     question.priority = Deft::Question::PRIORITY_MEDIUM
  #     question.first_question = true 
  #     question.next_question = proc do |user_nput| # ユーザ入力に応じて遷移先を振り分け
  #       # 変数 user_input に選択内容 ('blue, yellow' などの文字列) が入る
  #       # 必要に応じて、user_input に応じて遷移先を振り分ける処理を書く
  #       'example/next' # proc の評価値が次の遷移先となる
  #     end
  #   end
  #
  # == パスワードを入力 - password テンプレート
  #
  # パスワードなどの機密情報を入力させる種類の質問では、password テンプレートを用います。
  #
  # http://lucie.sourceforge.net/images/password-template.png
  #
  # 入力内容がすべて '*' でマスクされるため、string テンプレートと違い
  # 盗み見られる心配がありません。
  #
  # テンプレート定義、変数定義はほぼ string テンプレートと同じです。
  #
  #   template( 'example/password' ) do |template|
  #     template.template_type = 'password'
  #     template.short_description_ja = 'root パスワードを入力してください'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     password テンプレートではパスワードなどの機密情報を入力できます。
  #     string テンプレートとの違いは、入力内容がエコーバックされない点です。
  #     DESCRIPTION_JA
  #   end
  #
  #  question( 'example/password' ) do |question|
  #    question.priority = Deft::Question::PRIORITY_MEDIUM
  #    question.next_question = 'example/root_login'
  #  end
  #
  class AbstractTemplate
    # テンプレートクラス名 => テンプレート名のハッシュテーブル
    public
    def self.template2class_table # :nodoc:
      { Deft::TextTemplate => 'text',
        Deft::SelectTemplate => 'select',
        Deft::NoteTemplate => 'note',
        Deft::BooleanTemplate => 'boolean',
        Deft::StringTemplate => 'string',
        Deft::MultiselectTemplate => 'multiselect',
        Deft::PasswordTemplate => 'password' }
    end
    
    public 
    def initialize( nameString ) # :nodoc:
      @name = nameString
    end

    # テンプレート名を返す。
    public
    def name
      return @name
    end

    # 選択可能な項目を String の Array で返す。
    #
    #   aTemplate.choices => ["CHOICE 1", "CHOICE 2", "CHOICE 3"]
    #
    public
    def choices
      return @choices
    end
    
    # 選択可能な項目を String もしくは Array で以下のように指定する。
    #
    #   aTemplate.choices = ["CHOICE 1", "CHOICE 2", "CHOICE 3"]
    #   aTemplate.choices = "CHOICE 1, CHOICE 2, CHOICE 3"
    #
    public
    def choices=( _choices )
      type_check( "Choice", _choices, Array, String )
      case _choices
      when Array
        @choices = _choices
      when String
        @choices = _choices.split(/\s*,\s*/)
      end
    end

    # デフォルト値を String で返す。
    # 
    #   aTemplate.default => "DEFAULT VALUE"
    #
    public
    def default
      return @default
    end

    # デフォルト値を String で指定する。
    # 
    #   aTemplate.default = "DEFAULT VALUE"
    #
    public
    def default=( defaultString )
      type_check( "Default", defaultString, String )
      @default = defaultString
    end

    # 短いパッケージ説明を String で返す。
    # 
    #   aTemplate.short_description => "Short description about this metapackage"
    #
    public
    def short_description
      return @short_description
    end

    # 短いパッケージ説明を String で指定する。
    # 
    #   aTemplate.short_description = "Short description about this metapackage"
    #
    public
    def short_description=( descriptionString )
      type_check( "Short description", descriptionString, String )
      @short_description = descriptionString
    end

    # 短いパッケージ説明(日本語)を String で返す。
    # 
    #   aTemplate.short_description_ja => "メタパッケージの日本語による短い説明"
    #
    public
    def short_description_ja
      return @short_description_ja
    end

    # 短いパッケージ説明(日本語)を String で指定する。
    # 
    #   aTemplate.short_description_ja = "メタパッケージの日本語による短い説明"
    #
    public
    def short_description_ja=( descriptionString )
      type_check( "Short description JA", descriptionString, String )
      @short_description_ja = descriptionString
    end

    # 長いパッケージ説明(日本語)を String で返す。
    # 
    #   aTemplate.extended_description_ja => "メタパッケージの日本語による長い説明"
    #
    public
    def extended_description_ja
      return @extended_description_ja
    end

    # 長いパッケージ説明(日本語)を String で指定する。
    # 
    #   aTemplate.extended_description_ja = "メタパッケージの日本語による長い説明"
    #
    public
    def extended_description_ja=( descriptionString )
      type_check( "Extended description JA", descriptionString, String )
      @extended_description_ja = descriptionString
    end

    # 長いパッケージ説明を String で返す。
    # 
    #   aTemplate.extended_description => "Extended description about this metapackage"
    #
    public
    def extended_description
      return @extended_description
    end

    # 長いパッケージ説明を String で指定する。
    # 
    #   aTemplate.extended_description = "Extended description about this metapackage"
    #
    public
    def extended_description=( descriptionString )
      type_check( "Extended description", descriptionString, String )
      @extended_description = descriptionString
    end

    # デバッグ用
    public
    def inspect # :nodoc:
      return "#<Deft::AbstractTemplate: @name=\"#{@name}\">"
    end
    
    # 文字列に変換する
    public
    def to_s # :nodoc:
      unless ( (@short_description and @extended_description) or
               (@short_description_ja and @extended_description_ja) )
        raise Exception::RequiredAttributeException
      end
    end

    # テンプレート名を String で返す。
    #
    #   aTemplate = Deft::TextTemplate.new( "text template" )
    #   aTemplate.template_type => 'text'
    #
    public
    def template_type
      return AbstractTemplate.template2class_table[self.class]
    end

    private
    def type_check( attribute,  actualValue, *types )
      unless( types.any? do |each| actualValue.is_a?( each ) end )
        types_string = (types.map do |each| each.to_s end).join('/')
        raise Exception::InvalidAttributeException, "#{attribute} must be an #{types_string} object."
      end
    end

    private
    def template_string( typeString, *optionalFieldsArray )     
      _template_string =  "Template: #{name}\n"
      _template_string += "Type: #{typeString}\n"
      if optionalFieldsArray.include?( 'choices' ) && choices
        _template_string += "Choices: #{choices.join(', ')}\n" 
      end
      _template_string += "Default: #{default}\n" if optionalFieldsArray.include?( 'default' ) && default
      _template_string += "Description: #{short_description}\n" if short_description
      _template_string += extended_description.to_rfc822 + "\n" if extended_description
      _template_string += "Description-ja: #{short_description_ja}\n" if short_description_ja
      _template_string += extended_description_ja.to_rfc822 if extended_description_ja
      return _template_string
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
