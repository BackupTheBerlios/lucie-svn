#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'lucie'
require 'lucie/apt'
require 'lucie/chroot'
require 'lucie/debootstrap'
require 'lucie/shell'
require 'rake'
require 'rake/classic_namespace'
require 'rake/tasklib'


module Rake
  class InstallerBaseTask < TaskLib
    INSTALLER_BASE_DIR = '/var/lib/lucie/installer_base'.freeze


    attr_accessor :distribution
    attr_accessor :http_proxy
    attr_accessor :include
    attr_accessor :mirror
    attr_accessor :name
    attr_accessor :suite
    attr_accessor :target_directory


    def self.target_fname distribution, suite
      return distribution + '_' + suite + '.tgz'
    end


    def initialize name = :installer_base # :yield: self
      @name = name
      @target_directory = INSTALLER_BASE_DIR
      @mirror = 'http://www.debian.or.jp/debian/'
      yield self if block_given?

      define_tasks
    end


    private


    def task_name key
      return {
        :build => @name,
        :tgz => installer_base_target,
        :rebuild => paste( 're', @name ),
        :clobber => paste( 'clobber_', @name )
      }[ key ]
    end


    def target path
      return File.join( @target_directory, path )
    end


    def define_tasks
      define_task_build
      define_task_rebuild
      define_task_clobber
      define_task_tgz

      # define task dependencies.
      task task_name( :build ) => [ task_name( :tgz ) ]
      task task_name( :rebuild ) => [ task_name( :clobber ), task_name( :build ) ]
    end


    def define_task_build
      desc "Build installer base tarball for #{ @distribution } distribution, version = ``#{ @suite }''."
      task task_name( :build )
    end


    def define_task_rebuild
      desc 'Force a rebuild of the installer base tarball.'
      task task_name( :rebuild )
    end


    def define_task_clobber
      desc "Remove #{ @target_directory }"
      task task_name( :clobber ) do
        Lucie.info "Removing #{ @target_directory }"

        Kernel.sh 'umount', target( '/dev/pts' )

        ( Dir.glob( target( '/dev/.??*' ) ) + Dir.glob( target( '/*' ) ) ).each do | each |
          Kernel.sh 'rm', '-rf', each
        end

        # also remove files nfsroot/.? but not . and ..
        Shell.open do | shell |
          shell.on_stdout do | line |
            Kernel.sh 'rm', '-f', line
          end
          shell.exec env_lc_all, 'find', @target_directory, '-xdev', '-maxdepth', '1', '!', '-type', 'd'
        end
      end
    end


    def define_task_tgz
      file task_name( :tgz ) do
        Lucie.info "Creating base system using debootstrap version #{ Debootstrap.VERSION }"
        Lucie.info "Calling debootstrap #{ suite } #{ target_directory } #{ mirror }"

        Debootstrap.new do | option |
          option.env = env_lc_all.merge( 'http_proxy' => @http_proxy )
          option.exclude = [ 'dhcp-client', 'info' ]
          option.suite = @suite
          option.target = @target_directory
          option.mirror = @mirror
          option.include = @include
        end

        Apt.new( :clean ) do | option |
          option.root = @target_directory
        end

        Kernel.sh 'rm', '-f', target( '/etc/resolv.conf' )
        build_installer_base_tarball
      end
    end


    def env_lc_all
      return { 'LC_ALL' => 'C' }
    end


    def build_installer_base_tarball
      Lucie.info "Creating installer base tarball on #{installer_base_target}."
      Kernel.sh 'tar', '--one-file-system', '--directory', @target_directory, '--exclude', InstallerBaseTask.target_fname( @distribution, @suite ), '-czvf', installer_base_target, '.'
    end


    def installer_base_target
      return target( InstallerBaseTask.target_fname( @distribution, @suite ) )
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
