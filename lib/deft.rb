# = Deft ライブラリのメインファイル
#
# LMP 設定ファイルの頭では本ファイル (deft.rb) をかならず require し、
# template, question などのトップレベル関数を読み込むこと。
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'deft/boolean-template'
require 'deft/command-line-options'
require 'deft/multiselect-template'
require 'deft/note-template'
require 'deft/question'
require 'deft/select-template'
require 'deft/string-template'
require 'deft/template'
require 'singleton'

class DeftApp
  include Singleton
  
  # +questionNameString+ で表される Question の Ruby コードによる表現を返す
  public
  def ruby_code( questionNameString )
    question = Deft::Question[questionNameString]
    if question.nil? 
      raise( Deft::Question::Exception::InvalidQuestionException,
              "質問 '#{questionNameString}' は登録されていません" )
    end
    return question.marshal_concrete_state
  end
  
  # +templateNameString+ で表される Template の RFC-822 による表現を返す
  public
  def template( templateNameString )
    return Deft::Template[templateNameString].to_s
  end
  
  public
  def initialize
    @command_line_options = Deft::CommandLineOptions.instance
  end
  
  # メインルーチン
  public
  def main
    do_option
  end
  
  private
  def do_option    
    @command_line_options.parse ARGV.dup
    begin
      if @command_line_options.ruby_code        
        puts ruby_code( @command_line_options.ruby_code )        
      end
      if @command_line_options.template
        puts '登録されているテンプレートのリスト:'
        Deft::Template.templates.each do |each|
          puts each.name
        end
      end
      if @command_line_options.question
        puts '登録されている質問のリスト:'
        Deft::Question.questions.each do |each|
          puts each.name
        end
      end
    rescue Exception => e
      STDERR.puts e.message
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: