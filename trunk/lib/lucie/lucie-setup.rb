#!/usr/bin/env ruby
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'lucie/command-line-options'
require 'lucie/config'
require 'lucie/installer-base-task'
require 'lucie/logger'
require 'lucie/nfsroot-task'
require 'lucie/time-stamp'
require 'net/http'
require 'rake'
require 'singleton'

module Lucie
  update(%q$Id$)
  
  ##############################################################################
  # Lucie main application object.  When invoking +lucie-setup+ from the command
  # line, a Setup object is created and run.
  #
  #--
  # TODO: commoninstaller, diffinstaller のビルドを別タスクとしてくくり出す
  #++
  class Setup
    include Singleton
    
    LUCIE_VERSION = '0.0.4'
    VERSION_STRING = ['lucie-setup', LUCIE_VERSION, '('+$svn_date+')'].join(' ')
    
    # lucie-setup のメインルーチンを起動
    public
    def main
      begin
        do_option
      rescue RuntimeError => ex
        $stderr.puts( "ERROR: " + ex.message )
        exit(9)
      rescue SystemExit => ex
        $stderr.puts( ex.message ) unless( ex.success? )
        exit(0)
      end
      unless i_am_root
        $stderr.puts "Run this program as root."
        exit(9)
      end
      installer_base_task.invoke unless @commandline_options.diff_installer_name
      if @commandline_options.installer_base_only
        puts "lucie-setup finished."
        return 
      end
      begin
        if @commandline_options.diff_installer_name
          common_nfsroot_task.invoke 
          install_common_lmp
          diff_nfsroot_task.each do |each| each.invoke end
          install_diff_lmp
          modify_diff_installer
        elsif (not @commandline_options.installer_base_only)
          nfsroot_task.invoke 
        end
        puts "lucie-setup finished."
      rescue Exception => ex
        puts "lucie-setup aborted!"
        puts "ERROR: " + ex.message
        puts ex.backtrace.join("\n") if @commandline_options.trace
        exit( 1 )
      ensure
        umount_dirs
      end
      return nil
    end

    private
    def modify_diff_installer
      common_installer.installers.map do |each|
        File.join(@commandline_options.nfsroot_dir, 
                  diff_installer_name(common_installer.name, each.name), "/etc/init.d/rcS")
      end.each do |rcs|
        sh %{cp #{rcs} #{rcs}.orig}
        File.open( rcs, "w" ) do |file|
          File.open( rcs + ".orig", "r" ).each_line do |each|
            if /^require 'lucie\/installer\/extrbase/=~ each
              file.puts '# ' + each
            else
              file.puts each
            end
          end
        end
      end
    end

    private
    def install_diff_lmp
      lmp_list = get_common_lmps
      common_lmps = lmp_list[common_installer.installers[0]] & lmp_list[common_installer.installers[1]]
      common_installer.installers.each do |each|
        sh %{chroot #{File.join(@commandline_options.nfsroot_dir, diff_installer_name(common_installer.name, each.name))} apt-get install #{lmp_list[each] - common_lmps}}
      end
    end

    private
    def install_common_lmp
      lmp_list = get_common_lmps
      common_lmps = lmp_list[common_installer.installers[0]] & lmp_list[common_installer.installers[1]]
      puts %{Following LMPs are going to be installed on #{common_installer.name} installer: #{common_lmps.join(" ")}}
      common_lmps.each do |each|
        sh %{chroot #{File.join(@commandline_options.nfsroot_dir, common_installer.name)} apt-get install #{each}}
      end
    end

    private
    def get_common_lmps
      lmp_list = {}
      common_installer.installers.each do |si|
        print "Following LMPs are installed on #{si.name} installer: "
        lmp_list[si] = `chroot #{File.join(Rake::NfsrootTask::NFSROOT_DIR, si.name)} dpkg -l | grep "lmp-*"`.split("\n").map do |each|
          /^ii\s+(lmp-\S+)\s+.*/=~ each
          $1
        end
        puts lmp_list[si].join(", ")
      end
      return lmp_list
    end

    private
    def umount_dirs
      begin
        sh %{chroot #{nfsroot_dir} dpkg-divert --package lucie-client --rename --remove /sbin/discover-modprobe}, sh_option
        sh %{[ -d #{File.join(nfsroot_dir, 'proc/self')} ] && umount #{File.join(nfsroot_dir, 'proc')} || true}, sh_option
        sh %{[ -d #{File.join(nfsroot_dir, 'proc/self')} ] && umount #{File.join(nfsroot_dir, 'dev/pts')} || true}, sh_option
        sh %{mount | grep "on #{nfsroot_dir} " || true}, sh_option     
      rescue
        nil
      end
    end

    private
    def sh_option
      return {:verbose => @commandline_options.verbose}
    end

    private
    def i_am_root
      return true if (/mswin32\Z/=~ RUBY_PLATFORM)
      return (not (ENV['USER'] != 'root'))
    end
       
    private
    def list_lmp
      puts lmp_array.join("\n")
    end

    private
    def show_lmp
      unless lmp_array.include?( @commandline_options.show_lmp )
        raise "No such LMP: #{@commandline_options.show_lmp}" 
      end
      packages_body.split("\n\n").each do |each|
        puts each if /^Package: #{@commandline_options.show_lmp}/=~ each
      end
    end
    
    private
    def lmp_array
      lmps = []
      packages_body.each_line do |each|
          lmps.push $1 if /Package: (.*)/=~ each 
      end
      return lmps
    end
    
    private
    def packages_body
      Net::HTTP.version_1_2
      # XXX: サーバ名をどこかに定数としてまとめる。
      Net::HTTP.start('lucie-dev.titech.hpcc.jp', 80) do |http|
        return http.get('/packages/lmp/Packages').body
      end
    end

    # XXX: nfsroot-task 中の似たような処理と統合する
    private
    def enable_installer
      if Config::Installer[@commandline_options.enable_installer].nil?
        raise "No such installer resource: `#{@commandline_options.enable_installer}'"
      end

      sh_option = { :verbose => @commandline_options.verbose }
      installer_name = @commandline_options.enable_installer
      rm_f '/etc/dhcpd.conf', sh_option
      ln_s "/etc/dhcpd.conf.#{installer_name}", '/etc/dhcpd.conf', sh_option
      puts %{Restarting DHCP daemon.}
      sh %{/etc/init.d/dhcp restart}, sh_option
      
      rm_f '/etc/exports', sh_option
      ln_s "/etc/exports.#{installer_name}", '/etc/exports', sh_option
      puts %{Restarting NFS daemon.}
      sh %{/etc/init.d/nfs-kernel-server restart}, sh_option

      rm_f '/tftpboot/pxelinux.cfg', sh_option
      ln_s "/tftpboot/pxelinux.cfg.#{installer_name}", '/tftpboot/pxelinux.cfg', sh_option
    end
    
    private
    def do_option
      @commandline_options = CommandLineOptions.instance
      @commandline_options.parse ARGV.dup      
      if @commandline_options.enable_installer
        enable_installer
        exit(0)
      end
      if @commandline_options.show_lmp
        show_lmp
        exit(0)
      end
      if @commandline_options.list_lmp
        list_lmp
        exit(0)
      end
      if @commandline_options.list_installer
        list_installer
        exit(0)
      end
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
      if @commandline_options.lmp_install
        unless i_am_root
          $stderr.puts "Run this program as root."
          exit(9)
        end
        raise "Specify installer name with --installer-name option." unless @commandline_options.installer_name
        sh %{chroot #{nfsroot_dir} apt-get update}
        sh %{chroot #{nfsroot_dir} apt-get install #{@commandline_options.lmp_install}}
        exit
      end
    end
    
    private
    def list_installer
      Dir.glob( File.join(Rake::NfsrootTask::NFSROOT_DIR, "[^\.]*") ).each do |each|
        installer_stamp = File.join( each, Rake::NfsrootTask::INSTALLER_NAME_STAMP )
        if FileTest.exist?( installer_stamp )
          puts each + %{ (#{File.stat(installer_stamp).mtime})}
        else
          puts each + " (broken)"
        end
      end
    end

    private
    def common_installer
      return Config::DiffInstaller[@commandline_options.diff_installer_name]
    end

    private
    def diff_nfsroot_task
      tasks = []
      common_installer.installers.each do |each|
        tasks.push define_nfsroot_task(diff_installer_name(common_installer.name, each.name), each, common_installer)
      end
      return tasks
    end

    private
    def diff_installer_name( commonInstallerName, targetInstallerName )
      commonInstallerName + "_to_" + targetInstallerName
    end
    
    private
    def common_nfsroot_task
      return define_nfsroot_task( common_installer.name, common_installer.installers[0], common_installer )
    end

    private
    def nfsroot_task
      return define_nfsroot_task( installer.name, installer )
    end

    private
    def define_nfsroot_task( installerName, configInstaller, targetInstaller = nil )
      Rake::NfsrootTask.new( installerName ) do |nfsroot|
        nfsroot.dir = File.join( @commandline_options.nfsroot_dir, installerName )
        if targetInstaller
          nfsroot.source_installer = targetInstaller.installers.map do |each| each.name end
        end
        nfsroot.package_server       = configInstaller.package_server.uri
        nfsroot.distribution_version = configInstaller.distribution_version
        nfsroot.kernel_package       = configInstaller.kernel_package
        nfsroot.kernel_version       = configInstaller.kernel_version
        nfsroot.root_password        = configInstaller.root_password
        nfsroot.installer_base       = File.join( @commandline_options.installer_base_dir, 
                                                  Rake::InstallerBaseTask.target_fname(configInstaller.distribution, 
                                                                                       configInstaller.distribution_version) )
        nfsroot.extra_packages = configInstaller.extra_packages
      end
      return Task[installerName]
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
      raise "No such installer resource: `#{@commandline_options.installer_name}'" if installer.nil?
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
      klass = resource_name2class[@commandline_options.list_resource]
      if klass
        klass.list.each_value do |each| puts each end
      else
        raise( UnknownResourceTypeException,
               "Unknown resource type: '#{@commandline_options.list_resource}'" )
      end
    end

    private
    def resource_name2class
      return { 'host'           => Config::Host,
               'host_group'     => Config::HostGroup,
               'package_server' => Config::PackageServer,
               'dhcp_server'    => Config::DHCPServer,
               'installer'      => Config::Installer }
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
