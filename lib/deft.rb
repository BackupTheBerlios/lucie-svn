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
  
  DEFT_VERSION = '0.0.1'
  VERSION_STRING = ['deft', DEFT_VERSION, '('+$svn_date+')'].join(' ')
  
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
  
  # DeftApp オブジェクトを返す
  public
  def initialize
    @command_line_options = Deft::CommandLineOptions.instance
  end
  
  # メインルーチン
  public
  def main
    begin 
      do_option
    rescue Exception => ex
      puts "deft aborted!"
      puts ex.message
      if $trace
        puts ex.backtrace.join("\n")
      else
        # puts ex.backtrace.find { |str| str =~ /#{@rakefile}/ } || ""
      end
      exit( 1 )
    end
  end
  
  private
  def help
    puts VERSION_STRING
    puts
    usage
    puts
    puts "Options:"
    CommandLineOptions::OptionList::OPTION_LIST.each do |long, short, arg, desc|
      opt = sprintf("%25s", "#{long}, #{short}")
      oparg = sprintf("%-7s", arg)
      print "#{opt} #{oparg}"
      desc = desc.split("\n")
      if arg.nil? || arg.length < 7
        puts desc.shift
      else
        puts
      end
      desc.each do |line|
        puts(' '*33 + line)
      end
      puts
    end
  end
  
  private
  def usage
    puts "Usage: deft {options}"
  end
  
  private
  def do_option    
    @command_line_options.parse ARGV.dup
    if @command_line_options.trace
      $trace = true
    end
    if @command_line_options.version
      puts VERSION_STRING
      exit( 0 )
    end
    if @command_line_options.help
      help
      exit( 0 )
    end
    if @command_line_options.run
      ENV['DEBCONF_DEBUG'] = '.*'
      require @command_line_options.run
      exec "/usr/share/debconf/frontend #{$0} configure"
    end
    if @command_line_options.emulate
      next_question = Question::QUESTIONS[@command_line_options.emulate].next_question
      case next_question
      when String
        puts "`#{@command_line_options.emulate}' => `#{next_question}'"
      when Hash
        raise '--input option is not set' if @command_line_options.input.nil?
        puts "`#{@command_line_options.emulate}' => `#{next_question[@command_line_options.input]}'"
      when Proc
        raise '--input option is not set' if @command_line_options.input.nil?
        puts "`#{@command_line_options.emulate}' => `#{next_question.call( @command_line_options.input )}'"
      else
        raise "This shouldn't happen."
      end
      exit( 0 )
    end
    if @command_line_options.ruby_code        
      puts ruby_code( @command_line_options.ruby_code )        
    end
    if @command_line_options.template
      Deft::Template.templates.each do |each|
        puts each.name
      end
    end
    if @command_line_options.question
      Deft::Question.questions.each do |each|
        puts each.name
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: