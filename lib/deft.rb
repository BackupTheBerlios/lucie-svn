#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'deft/command-line-options'
require 'deft/question'
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
    return Lucie::Template[templateNameString].to_s
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
    if @command_line_options.ruby_code
      begin
        puts ruby_code( @command_line_options.ruby_code )
      rescue Exception => e
        STDERR.puts e.message
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: