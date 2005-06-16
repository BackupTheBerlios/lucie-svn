#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'depends'
require 'lmp/command-line-options'
require 'lmp/read-config'

class LMPApp
  include Singleton

  LMP_VERSION = '0.0.2'
  VERSION_STRING = ['lmp', LMP_VERSION].join(' ')

  public
  def initialize
    @command_line_options = LMP::CommandLineOptions.instance
  end

  # メインルーチン
  public
  def main
    @pool = nil
    begin 
      do_option
    rescue SystemExit
      # Do Nothing
    rescue Exception => ex
      puts "lmp aborted!"
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
  def do_option    
    @command_line_options.parse ARGV.dup
    if @command_line_options.version
      puts VERSION_STRING
      exit( 0 )
    end
    if @command_line_options.help
      help
      exit( 0 )
    end
    if @command_line_options.conflict_with
      @pool ||= Depends::Pool.new
      package_list_inconsistency_check

      config_reader = LMP::ReadConfig.new
      config_reader.read( @command_line_options.conflict_with )
      other_package_list = config_reader.packages[:install]
      package_list.each do |each| 
        other_package_list.each do |other_package|
          puts %{#{each} <=> #{other_package}} if @pool.conflict?( each, other_package )
        end
      end
    end
    if @command_line_options.depend_to
      @pool ||= Depends::Pool.new
      config_reader = LMP::ReadConfig.new
      config_reader.read( @command_line_options.depend_to )

      # depends の計算
      other_package_list = config_reader.packages[:install]
      package_list.each do |each|
        depends = (@pool.deps( each, 10 )[:forward].collect do |package| package.name end).uniq
        puts %{#{each} => #{(depends & other_package_list).join(', ')}} if ((depends & other_package_list) != [] )
      end

      # provided-depends の計算
      package_list.each do |each|
        provided_depends = (@pool.deps( each, 10 )[:provided].collect do |package| package.name end).uniq
        puts %{#{(provided_depends & other_package_list).join(', ')} => #{each}} if ((provided_depends & other_package_list) != [] )
      end
    end
  end

  private
  def package_list_inconsistency_check
    package_list.each_with_index do |each, index|
      (0..(package_list.size-1)).each do |other_index|
        if (index != other_index) && @pool.conflict?( each, package_list[other_index] )
          puts %{#{each} <=> #{package_list[other_index]}} 
        end
      end
    end
  end

  private
  def package_list
    config_reader = LMP::ReadConfig.new
    config_reader.read( @command_line_options.package_list )
    return config_reader.packages[:install]
  end

  private
  def help
    puts VERSION_STRING
    puts
    usage
    puts
    puts "Options:"
    LMP::CommandLineOptions::OptionList::OPTION_LIST.each do |long, short, arg, desc|
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
    puts "Usage: lmp {options}"
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
