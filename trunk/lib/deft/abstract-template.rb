#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/string'
require 'time-stamp'

# FIXME: モジュール/クラス定義の内側へ追いやる
update(%q$Id$)

module Deft
  module Exception
    class InvalidAttributeException < ::Exception; end
    class RequiredAttributeException < ::Exception; end
  end

  # == テンプレートの基礎
  #
  # Debconf には、「テンプレート」と「変数」と呼ばれる概念があります。
  # Debconf による設定ダイアログの開発者は、まずユーザに表示したい質問
  # 項目をリストアップし、各質問項目に対応するテンプレートと変数を定義
  # する必要があります。
  #
  # Debconf についてより詳しくは {こちら}[http://www.debian.org/doc/packaging-manuals/debconf_specification.html] 
  # を参照。
  # 
  # === テンプレート
  # 
  # テンプレートはユーザに表示する質問項目の雛形を指定するものです。テ
  # ンプレートには名前、型、デフォルト値、説明があります
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
  # * string: 文字列
  # * boolean: true か false
  # * select: `Choices:' に設定されている空白もしくはコンマで区切られた複数の値から一つ
  # * multiselect: select は一つしか選べないのに対して複数選べる
  # * note: たんに ‘Description:’ の説明を提示するだけ。メールもおくる
  # * text: `Description:' の説明を提示する
  # * 入力するときに echo back しない string
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
  # === 状態遷移
  #
  # また、開発者はテンプレートと変数に加え、ユーザ入力に応じた画面間の
  # 遷移を記述する必要があります。たとえば、最初の質問画面で「犬と猫は
  # どちらが好きか？」という選択をさせた場合、ユーザが犬を選んだ場合に
  # は犬に関する質問を続ける、というような場合です。
  #
  # == メッセージの表示 - text テンプレート
  #
  # text 型のテンプレートを用いることによって、ユーザへメッセージを表
  # 示することができます。以下は note 型テンプレート 
  # lucie-vmsetup/hello の例です。
  #
  #   template( 'lucie-vmsetup/hello' ) do |template|
  #     template.template_type = 'text'
  #     template.short_description_ja = 'Lucie VM のセットアップウィザードへようこそ'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     このウィザードでは、Lucie を用いた VM セットアップの設定を入力します。
  #     設定可能な項目は、
  #      o 必要な VM の台数
  #      o 外部ネットワークへの接続
  #      o VM で使用するメモリ容量
  #      o VM で使用するハードディスク容量
  #      o 使用する VM の種類
  #      o VM へインストールする Linux ディストリビューションの種類
  #      o VM へインストールするソフトウェアの種類
  #     です。自分が VM 上で走らせたいジョブの特性によって設定を決めてください。
  #  
  #     「次へ」をクリックするとウィザードを開始します。
  #     DESCRIPTION_JA
  #   end
  #
  # text 型のテンプレートでは、プロパティ template_type に 
  # TextTemplate を指定します。
  #
  # 次に、このテンプレートを元にして変数 lucie-vmsetup/hello を定義し
  # ます。
  #
  #   question( 'lucie-vmsetup/hello' ) do |question|
  #     question.priority = Question::PRIORITY_MEDIUM
  #     question.next_question = 'lucie-vmsetup/num-nodes'
  #     question.first_question = true
  #   end
  #
  # question の各プロパティの意味は以下の通りです。
  #
  # * priority : 質問の優先度。利用可能な定数は Question クラスに定義されています。
  # * next_question : 次の質問。
  # * first_question : 最初の質問である場合、true を設定します。
  #
  # Debconf の表示は以下のようになります。
  # 
  # http://lucie.berlios.de/images/debconf-tool-tutorial/snapshot1.png
  #
  # == メッセージを表示し、メールも送る - note テンプレート
  #
  # 設定情報などといったとくに重要なメッセージを表示し、また reminder 
  # として保存させておきたい場合、note 型のテンプレートを用います。基
  # 本的には text 型のテンプレートと変わらず、型が note になるだけです。
  #
  #   template( 'lucie-vmsetup/hello' ) do |template|
  #     template.template_type = 'note'
  #     template.short_description_ja = 'Lucie VM のセットアップウィザードへようこそ'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     このウィザードでは、Lucie を用いた VM セットアップの設定を入力します。
  #     設定可能な項目は、
  #      o 必要な VM の台数
  #      o 外部ネットワークへの接続
  #      o VM で使用するメモリ容量
  #      o VM で使用するハードディスク容量
  #      o 使用する VM の種類
  #      o VM へインストールする Linux ディストリビューションの種類
  #      o VM へインストールするソフトウェアの種類
  #     です。自分が VM 上で走らせたいジョブの特性によって設定を決めてください。
  #
  #     「次へ」をクリックするとウィザードを開始します。
  #     DESCRIPTION_JA
  #   end
  #
  # もちろん、変数の書き方は text 型の場合と同じです。
  #
  # Debconf の表示は以下のようになります。
  #
  # http://lucie.berlios.de/images/debconf-tool-tutorial/snapshot1.png
  #
  # == YES/NO の質問を表示 - boolean テンプレート
  #
  # 「ハイ」「イイエ」で答えられる種類の質問では、boolean 型のテンプレートを用います。
  #
  #   template( 'lucie-vmsetup/use-network' ) do |template|
  #     template.template_type = 'boolean'
  #     template.default = 'false'
  #     template.short_description_ja = 'VM の外部ネットワークへの接続'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     ジョブ実行時に VM は外部ネットワークへ接続する必要がありますか？
  #     このオプションをオンにすると、GRAM が自動的に各 VM に連続した IP アドレスと MAC アドレスを割り当て、
  #     Lucie をすべてのネットワーク関係の設定を行います。
  #     DESCRIPTION_JA
  #   end
  #
  # 変数は以下のようになります。
  #
  #   question( 'lucie-vmsetup/use-network' ) do |question|
  #     question.priority = Question::PRIORITY_MEDIUM
  #     question.next_question = { 'true'=>'lucie-vmsetup/ip', 'false'=>'lucie-vmsetup/memory-size' }
  #   end  
  #
  # Debconf の表示は以下のようになります。
  #
  # http://lucie.berlios.de/images/debconf-tool-tutorial/snapshot3.png
  # 
  # == 文字列を入力 - string テンプレート
  #
  # ユーザになんらかの入力をうながす種類の質問では、string 型のテンプ
  # レートを用います。
  #
  #   template( 'lucie-vmsetup/application' ) do |template|
  #     template.template_type = 'string'
  #     template.short_description_ja = '使用するアプリケーション'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     VM にインストールして使用するソフトウェアパッケージを入力してください
  #
  #     松岡研 PrestoIII クラスタでデフォルトでインストールされるソフトウェアパッケージは以下の通りです。
  #      o 基本パッケージ: fileutils, findutils などの基本的なユーティリティ
  #      o シェル: tcsh, bash, zsh などのシェル
  #      o ネットワークデーモン: ssh や rsh, ftp などのデーモン
  #     上記に追加してインストールしたいパッケージをコンマ区切りで入力してください。
  #
  #     例: ruby, python, blast2
  #     DESCRIPTION_JA
  #   end
  #
  # 変数は以下のようになります。
  #
  #   question( ‘lucie-vmsetup/application’ ) do |question|
  #     question.priority = Question::PRIORITY_MEDIUM
  #   end
  #
  # http://lucie.berlios.de/images/debconf-tool-tutorial/snapshot9.png
  #
  # == 選択肢の中から一つだけ選択 - select テンプレート
  #
  # 選択肢の中からひとつを選ばせる種類の質問では、select 型のテンプレートを用います。
  #
  #   template( 'lucie-vmsetup/num-nodes' ) do |template|
  #     template.template_type = 'select'
  #     template.choices = '4, 8, 12, 16, 20'
  #     template.short_description_ja = 'VM ノードの台数'
  #     template.extended_description_ja = <<-DESCRIPTION_JA
  #     使用したい VM の台数を選択してください。
  #
  #     松岡研 PrestoIII クラスタで提供できる VM クラスタのノード数は、4 台�� 64 台となっています。
  #     他のジョブへ影響を与えないように、ジョブ実行に *最低限* 必要な台数を選択してください。
  #     DESCRIPTION_JA
  #   end
  #
  # choices プロパティで選択肢を指定していることに注目してください。
  #
  # 変数は以下のようになります。
  #
  #   question( 'lucie-vmsetup/num-nodes' ) do |question|
  #     question.priority = Question::PRIORITY_MEDIUM
  #     question.next_question = 'lucie-vmsetup/use-network'
  #   end  
  #
  # http://lucie.berlios.de/images/debconf-tool-tutorial/snapshot2.png
  #
  # == 選択肢の中から複数選択 - multiselect テンプレート
  #
  # == パスワードを入力 - password テンプレート
  #
  # すべてのテンプレートクラスの親となるクラス。テンプレートの各アトリ
  # ビュートへのアクセッサメソッド等の共通するメソッドを提供する。テン
  # プレートを追加するといった場合以外にはこのクラスを直接使用すること
  # は無い。
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
    
    # 選択可能な項目を String の Array で指定する。
    #
    #   aTemplate.choices = ["CHOICE 1", "CHOICE 2", "CHOICE 3"]
    #
    public
    def choices=( choiceArray )
      type_check( "Choice", Array, choiceArray )
      @choices = choiceArray
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
      type_check( "Default", String, defaultString )
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
      type_check( "Short description", String, descriptionString )
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
      type_check( "Short description JA", String, descriptionString )
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
      type_check( "Extended description JA", String, descriptionString )
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
      type_check( "Extended description", String, descriptionString )
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
    def type_check( attribute, type, actualValue )
      unless actualValue.is_a?( type )
        raise Exception::InvalidAttributeException, "#{attribute} must be an #{type.to_s} object."
      end
    end

    private
    def template_string( typeString, *optionalFieldsArray )     
      _template_string =  "Template: #{name}\n"
      _template_string += "Type: #{typeString}\n"
      if optionalFieldsArray.include?( 'choices' ) && choices
        case choices
        when String
          _template_string += "Choices: #{choices}\n" 
        when Array
          _template_string += "Choices: #{choices.join(', ')}\n" 
        else
          raise "This shouldn't happen"
        end
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
