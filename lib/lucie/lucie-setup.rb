#!/usr/bin/env ruby
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'lucie/config'
require 'lucie/nfsroot-task'
require 'lucie/installer-base-task'
require 'lucie/command-line-options'
require 'lucie/time-stamp'
require 'rake'
require 'singleton'

module Lucie
  
  update(%q$Date$) 
  
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
      do_option
      unless i_am_root
        $stderr.puts "Run this program as root."
        exit(9)
      end
      begin
        installer_base_task.invoke
        nfsroot_task.invoke
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
      load_configuration
      if @commandline_options.list_resource
        list_resource 
        exit
      end
    end
    
    private
    def nfsroot_task
      installer = Config::Installer[@commandline_options.installer_name]
      Rake::NfsrootTask.new( installer.name ) do |nfsroot|
        nfsroot.dir = File.join( @commandline_options.nfsroot_dir, installer.name )
        nfsroot.installer_base = File.join( File.join( @commandline_options.installer_base_dir, installer.name ), 
          "#{installer.distribution}_#{installer.distribution_version}.tgz" )
      end
      return Task[installer.name]
    end
    
    private
    def installer_base_task
      installer = Config::Installer[@commandline_options.installer_name]
      Rake::InstallerBaseTask.new( installer_base_task_name( installer.name ) ) do |installer_base|
        installer_base.dir = File.join( @commandline_options.installer_base_dir, installer.name )
        installer_base.mirror = installer.package_server.uri
        installer_base.distribution = installer.distribution
        installer_base.distribution_version = installer.distribution_version
      end
      return Task[installer_base_task_name( installer.name )]
    end
    
    private 
    def installer_base_task_name( installerNameString )
      return installerNameString + '_base'
    end
    
    private
    def list_resource
      case @commandline_options.list_resource
      when 'host'
        Config::Host.list.each_value do |each| puts each end
      when 'host_group'
        Config::HostGroup.list.each_value do |each| puts each end    
      when 'package_server'
        Config::PackageServer.list.each_value do |each| puts each end 
      when 'dhcp_server'
        Config::DHCPServer.list.each_value do |each| puts each end  
      when 'installer'
        Config::Installer.list.each_value do |each| puts each end 
      else
        # TODO: 例外を raise
      end
    end
    
    private
    def load_configuration
      require File.join( @commandline_options.config_dir, 'resource.rb' )
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
