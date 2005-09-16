# = Deft ライブラリのメインファイル
#
# Deft 設定ファイルの頭では本ファイル (deft.rb) をかならず require し、
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
require 'deft/password-template'
require 'deft/question'
require 'deft/select-template'
require 'deft/string-template'
require 'deft/template'
require 'deft/text-template'
require 'deft/time-stamp'
require 'fileutils'
require 'lmp/lmp-package-task'
require 'lmp/specification'
require 'nkf'
require 'singleton'
require 'tempfile'

Deft::update(%q$Id$)

class DeftApp
  include Singleton
  
  DEFT_VERSION = '0.0.2'
  VERSION_STRING = ['deft', DEFT_VERSION, '('+$svn_date+')'].join(' ')
  
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
    rescue SystemExit
      # Do Nothing
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
    Deft::CommandLineOptions::OptionList::OPTION_LIST.each do |long, short, arg, desc|
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
  def run
    backend = Tempfile.new( 'deft' )
    
    require @command_line_options.run
    File.open( backend.path + '.templates', 'w+' ) do |file|
      Deft::Template.templates.each do |each|
        file.puts NKF.nkf( '-e', each.to_s )
        file.puts 
      end
    end

    backend.print <<-BACKEND
#!/usr/bin/ruby
require 'deft/debconf-context'
require '#{@command_line_options.run}'

capb  'backup'
title 'Deft'
    BACKEND
    Deft::Question.questions.each do |each|
      unless each.name == each.template
        backend.puts "register '#{each.template}', '#{each.name}'"
      end
    end
    backend.print <<-BACKEND
debconf_context = Deft::DebconfContext.new  
loop do 
  rc = debconf_context.transit
  exit 0 if rc.nil?
end
      BACKEND
    backend.close
 
    ENV['DEBCONF_DEBUG'] = '.*'
    FileUtils.chmod( 0755, backend.path )    
    exec %{/usr/share/debconf/frontend #{backend.path} #{ARGV.join(' ')}}
  end

  private
  def do_option    
    @command_line_options.parse ARGV.dup
    $trace = true if @command_line_options.trace
    if @command_line_options.version
      puts VERSION_STRING
      exit( 0 )
    end
    if @command_line_options.help
      help
      exit( 0 )
    end
    if @command_line_options.run      
      run
    end
    if @command_line_options.template
      require @command_line_options.template
      Deft::Template.templates.each do |each|
        puts each.name
      end
    end
    if @command_line_options.question
      require @command_line_options.question
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
