#!/usr/bin/env ruby
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'lucie/command-line-options'
require 'lucie/time-stamp'
require 'rake'
require 'singleton'

module Lucie
  
  update(%q$Date: 2005-01-21 16:03:36 +0900 (Fri, 21 Jan 2005) $) 
  
  ##############################################################################
  # Lucie main application object.  When invoking +lucie-setup+ from the command
  # line, a Setup object is created and run.
  #
  class Setup
    include Singleton
    
    LUCIE_VERSION = '0.0.1'
    VERSION_STRING = ['lucie-setup', LUCIE_VERSION, '('+Lucie::svn_date+')'].join(' ')
    
    # lucie-setup のメインルーチンを起動
    public
    def main
      unless i_am_root
        $stderr.puts "Run this program as root."
        exit(9)
      end
      do_option
      begin
        tasks = collect_tasks
        load_rakefile
        tasks.each do |task_name| Task[task_name].invoke end
      rescue Exception => ex
        puts "lucie-setup aborted!"
        puts ex.message
        if $trace
          puts ex.backtrace.join("\n")
        else
          puts ex.backtrace.find { |str| str =~ /#{@rakefile}/ } || ""
        end
        exit(1)
      end
      return nil
    end
    
    private
    def i_am_root
      return true if (/mswin32\Z/=~ RUBY_PLATFORM)
      return (not (ENV['USER'] != 'root'))
    end
    
    #--
    # FIXME : ロードのパスを直す (コマンドラインオプションで指定可能に？)
    #++
    private
    def load_rakefile
      Dir.glob( 'lib/lucie/rake/*.rb' ).each do |each|
        load each
      end
    end
    
    # Collect the list of tasks on the command line.  If no tasks are
    # give, return a list containing only the default task.
    # Environmental assignments are processed at this time as well.
    #--
    # FIXME : コマンドラインオプションで実行するタスクを選べるようにする
    #++
    private
    def collect_tasks
      tasks = []
      tasks.push("default") if tasks.size == 0
      return tasks
    end
    
    private
    def do_option
      @commandline_options = CommandLineOptions.instance
      @commandline_options.parse ARGV.dup
      if @commandline_options.help
        help
        exit
      end
      if @commandline_options.version
        puts VERSION_STRING
        exit
      end
      exit(0) if @commandline_options.list_resource
    end
    
    private
    def usage
      puts "Usage: lucie-setup {options}"
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
  end 
end

########
# Main #
########

if __FILE__ == $PROGRAM_NAME
  Lucie::Setup.instance.main
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
