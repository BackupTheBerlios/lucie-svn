# = Deft ���C�u�����̃��C���t�@�C��
#
# LMP �ݒ�t�@�C���̓��ł͖{�t�@�C�� (deft.rb) �����Ȃ炸 require ���A
# template, question �Ȃǂ̃g�b�v���x���֐���ǂݍ��ނ��ƁB
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
  
  # +questionNameString+ �ŕ\����� Question �� Ruby �R�[�h�ɂ��\����Ԃ�
  public
  def ruby_code( questionNameString )
    question = Deft::Question[questionNameString]
    if question.nil? 
      raise( Deft::Question::Exception::InvalidQuestionException,
              "���� '#{questionNameString}' �͓o�^����Ă��܂���" )
    end
    return question.marshal_concrete_state
  end
  
  # +templateNameString+ �ŕ\����� Template �� RFC-822 �ɂ��\����Ԃ�
  public
  def template( templateNameString )
    return Deft::Template[templateNameString].to_s
  end
  
  public
  def initialize
    @command_line_options = Deft::CommandLineOptions.instance
  end
  
  # ���C�����[�`��
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
        puts '�o�^����Ă���e���v���[�g�̃��X�g:'
        Deft::Template.templates.each do |each|
          puts each.name
        end
      end
      if @command_line_options.question
        puts '�o�^����Ă��鎿��̃��X�g:'
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