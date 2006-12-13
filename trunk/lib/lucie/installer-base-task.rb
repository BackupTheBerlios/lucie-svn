#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


require 'lucie/apt'
require 'lucie/chroot'
require 'lucie/command-line-options'
require 'lucie/debootstrap'
require 'lucie/shell'
require 'rake'
require 'rake/tasklib'


module Rake
  class InstallerBaseTask < TaskLib
    INSTALLER_BASE_DIR = '/var/lib/lucie/installer_base'.freeze


    attr_accessor :name
    attr_accessor :target_directory
    attr_accessor :mirror
    attr_accessor :distribution
    attr_accessor :suite


    def self.target_fname( distribution, suite )
      return distribution + '_' + suite + '.tgz'
    end


    def initialize( name=:installer_base ) # :yield: self
      @name = name
      @target_directory = INSTALLER_BASE_DIR
      @mirror = 'http://www.debian.or.jp/debian/'
      yield self if block_given?
      define
    end


    private


    def define
      desc "Build installer base tarball for #{ @distribution } distribution, version = ``#{ @suite }''."
      task @name

      desc "Force a rebuild of the installer base tarball."
      task paste( "re", @name ) => [ paste( "clobber_", @name ), @name ]

      desc "Remove the installer base tarball."
      task paste( "clobber_", @name ) do
        cleanup_temporary_directory
      end

      task :clobber => [ paste( "clobber_", @name ) ]

      directory @target_directory
      task @name => [ installer_base_target ]

      file installer_base_target do
        info "Creating base system using debootstrap version #{ Debootstrap.VERSION }"
        info "Calling debootstrap #{ suite } #{ target_directory } #{ mirror }"
        Debootstrap.new do | option |
          option.env = { 'LC_ALL' => 'C' }
          option.exclude = [ 'dhcp-client', 'info' ]
          option.suite = @suite
          option.target = @target_directory
          option.mirror = @mirror
        end

        Apt.new( :clean ) do | option |
          option.root = @target_directory
        end

        Kernel.sh 'rm', File.join( @target_directory, '/etc/resolv.conf' )
        build_installer_base_tarball
        cleanup_temporary_directory
      end
    end


    def build_installer_base_tarball
      info "Creating installer base tarball on #{installer_base_target}."
      Kernel.sh 'tar', '-l', '--directory', @target_directory, '-czvf', installer_base_target, '.'
    end


    def cleanup_temporary_directory
      info "Removing debootstrap temporary directory."
      Kernel.sh 'rm', '-rf', @target_directory
    end


    def info( aString )
      # logger.info aString
      puts aString
    end


    def installer_base_target
      return File.join( @target_directory, InstallerBaseTask.target_fname( @distribution, @suite ) )
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
