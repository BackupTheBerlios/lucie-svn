#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'lucie'
require 'popen3/apt'
require 'popen3/debootstrap'
require 'popen3/shell'
require 'rake'
require 'rake/classic_namespace'
require 'rake/tasklib'


module Rake
  class InstallerBaseTask < TaskLib
    include Kernel
    include Lucie


    INSTALLER_BASE_DIR = '/var/lib/lucie/installer_base'.freeze
    MIRROR_URI = 'http://www.debian.or.jp/debian/'.freeze


    attr_accessor :distribution
    attr_accessor :http_proxy
    attr_accessor :include
    attr_accessor :mirror
    attr_accessor :name
    attr_accessor :suite
    attr_accessor :target_directory


    def initialize name = :installer_base # :yield: self
      @name = name
      @target_directory = INSTALLER_BASE_DIR
      @mirror = MIRROR_URI
      @http_proxy = nil
      yield self if block_given?
      Popen3::Shell.logger = Lucie
      define_tasks
    end


    def installer_base_target
      return target( target_fname( @distribution, @suite ) )
    end
    alias :tgz :installer_base_target


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
        sh_exec 'rm', '-rf', @target_directory
      end
    end


    def define_task_tgz
      file task_name( :tgz ) do
        info "Creating base system using debootstrap version #{ Popen3::Debootstrap.VERSION }"
        info "Calling debootstrap #{ suite } #{ target_directory } #{ mirror }"

        debootstrap do | option |
          option.logger = Lucie
          option.env = env_lc_all.merge( 'http_proxy' => @http_proxy )
          option.exclude = [ 'dhcp-client', 'info' ]
          option.suite = @suite
          option.target = @target_directory
          option.mirror = @mirror
          option.include = @include
        end

        aptget_clean :root => @target_directory, :logger => Lucie

        sh_exec 'rm', '-f', target( '/etc/resolv.conf' )
        build_installer_base_tarball
      end
    end


    def build_installer_base_tarball
      info "Creating installer base tarball on #{ installer_base_target }."
      sh_exec 'tar', '--one-file-system', '--directory', @target_directory, '--exclude', target_fname( @distribution, @suite ), '-czvf', installer_base_target, '.'
    end


    def target_fname distribution, suite
      return distribution + '_' + suite + '.tgz'
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
