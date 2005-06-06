#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'
require 'rake/tasklib'
require 'lucie/command-line-options'

module Rake
  class InstallerBaseTask < TaskLib
    attr_accessor :name
    attr_accessor :dir
    attr_accessor :mirror
    attr_accessor :distribution
    attr_accessor :distribution_version
    
    public
    def initialize( name=:installer_base ) # :yield: self
      @name = name
      @dir = '/var/lib/lucie/installer-base/'
      @mirror = 'http://www.debian.or.jp/debian/'
      yield self if block_given?
      define
    end
    
    private
    def define
      desc "Build the #{distribution} version #{distribution_version} installer base tarball"
      task name
      
      desc "Force a rebuild of the installer base tarball"
      task paste("re", name) => [paste("clobber_", name), name]
      
      desc "Remove installer base filesystem"
      task paste("clobber_", name) do 
        rm_r @dir rescue nil
      end
      
      task :clobber => [paste("clobber_", name)]
      
      directory @dir
      task name => [installer_base_target]
      
      file installer_base_target do
        debootstrap_option = "--arch i386 --exclude=#{exclude_packages.join(',')} --include=ncurses-term"
        info "Executing debootstrap. This may take a long time."
        sh_log( %{yes '' | LC_ALL=C debootstrap #{debootstrap_option} #{@distribution_version} #{@dir} #{@mirror} 2>&1}, sh_option ) do |rd|
          line_length = 0
          while (rd.gets)
            line = $_.chomp
            case line
            when /^I: /
              STDERR.print ' ' * line_length, "\r"
              STDERR.print line, "\r"
              line_length = line.length
              logger.info line
            when /^E: /
              logger.error line 
              raise DebootstrapExecutionError, line
            else
              logger.debug line 
            end
          end
        end
        sh %{chroot #{@dir} apt-get clean}, sh_option
        rm File.join(@dir, '/etc/resolv.conf'), {:force=>true}.merge( sh_option )

        info "Creating installer base tarball on #{installer_base_target}."
        sh %{tar -l -C #{@dir} -cf - --exclude #{File.join('var/tmp', target_fname)} . | gzip > #{installer_base_target}}, sh_option       
      end
    end
    
    private
    def info( aString )
      logger.info aString
      puts aString
    end

    private
    def logger
      return Lucie::Logger::instance
    end 

    private
    def sh_option
       return {:verbose => Lucie::CommandLineOptions.instance.verbose} 
    end
    
    private
    def exclude_packages
      return ['pcmcia-cs,ppp', 'pppconfig', 'pppoe', 'pppoeconf', 
               'dhcp-client', 'exim4', 'exim4-base', 'exim4-config',
               'exim4-daemon-light', 'mailx', 'at', 'fdutils', 'info', 
               'modconf', 'libident', 'logrotate', 'exim'] 
    end
    
    private
    def target_fname
      return @distribution+'_'+@distribution_version+'.tgz'
    end
    
    private
    def installer_base_target
      return File.join(@dir, 'var/tmp', target_fname)
    end
    
    class DebootstrapExecutionError < ::StandardError; end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
