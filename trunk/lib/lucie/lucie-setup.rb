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
    
    LUCIE_VERSION = '0.0.2alpha'
    VERSION_STRING = ['lucie-setup', LUCIE_VERSION, '('+Lucie::svn_date+')'].join(' ')
    
    # lucie-setup のメインルーチンを起動
    public
    def main
      begin
        do_option
      rescue Exception => ex
        puts ex.message
        exit(1)
      end
      unless i_am_root
        $stderr.puts "Run this program as root."
        exit(9)
      end
      begin
        installer_base_task.invoke
        nfsroot_task.invoke
        puts "lucie-setup finished."
      rescue Exception => ex
        puts "lucie-setup aborted!"
        puts ex.message
        if @commandline_options.trace
          puts ex.backtrace.join("\n")
        end
        exit(1)
      ensure
        umount_dirs
      end
      return nil
    end
    
    private
    def umount_dirs
      sh_option = {:verbose => @commandline_options.verbose}
      sh %{LC_ALL=C chroot #{nfsroot_dir} dpkg-divert --package lucie-client --rename --remove /sbin/discover-modprobe}, sh_option rescue nil
      sh %{umount #{File.join(nfsroot_dir, 'proc')} || true}, sh_option
      sh %{umount #{File.join(nfsroot_dir, 'dev/pts')} || true}, sh_option
      sh %{mount | grep "on #{nfsroot_dir} " || true}, sh_option     
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
      Rake::NfsrootTask.new( installer.name ) do |nfsroot|
        nfsroot.dir = nfsroot_dir
        nfsroot.package_server = installer.package_server.uri
        nfsroot.distribution_version = installer.distribution_version
        nfsroot.kernel_package = installer.kernel_package
        nfsroot.kernel_version = installer.kernel_version
        nfsroot.root_password = installer.root_password
        nfsroot.installer_base = File.join( @commandline_options.installer_base_dir, 
                                            installer.name, 'var/tmp', basetgz_filename)
      end
      return Task[installer.name]
    end
    
    private
    def basetgz_filename
      return "#{installer.distribution}_#{installer.distribution_version}.tgz"
    end

    private
    def nfsroot_dir
      return File.join( @commandline_options.nfsroot_dir, installer.name )
    end
    
    private
    def installer
      return Config::Installer[@commandline_options.installer_name]
    end
    
    private
    def installer_base_task
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
        raise( UnknownResourceTypeException,
               "Unknown resource type: '#{@commandline_options.list_resource}'" )
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

    class UnknownResourceTypeException < ::Exception; end
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
