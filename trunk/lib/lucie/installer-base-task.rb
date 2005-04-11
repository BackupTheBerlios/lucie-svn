#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'
require 'rake/tasklib'
require 'lucie/command-line-options'

Lucie::update(%q$Date$)

module Rake
  #
  # ’¥¤’¥ó’¥¹’¥È’¡¼’¥é’¤Î’¥Ù’¡¼’¥¹’¥·’¥¹’¥Æ’¥à’¤ò’¥Ó’¥ë’¥É’¤¹’¤ë’¥¿’¥¹’¥¯’¤ò’ºî’À®’¤¹’¤ë’¡£
  #
  # InstallerBaseTask ’¤Ï’¼¡’¤Î’¥¿’¡¼’¥²’¥Ã’¥È’¤ò’ºî’À®’¤¹’¤ë:
  #
  # [<b><em>installer_base</em></b>]
  #   InstallerBase ’¥¿’¥¹’¥¯’¤Î’¥á’¥¤’¥ó’¥¿’¥¹’¥¯
  # [<b><em>:clobber_installer_base</em></b>]
  #   ’¤¹’¤Ù’¤Æ’¤Î’¥¤’¥ó’¥¹’¥È’¡¼’¥é’¥Ù’¡¼’¥¹’´Ø’Ï¢’¥Õ’¥¡’¥¤’¥ë’¤ò’¾Ã’µî’¤¹’¤ë’¡£
  #   ’¤³’¤Î’¥¿’¡¼’¥²’¥Ã’¥È’¤Ï’¼«’Æ°’Åª’¤Ë’¥á’¥¤’¥ó’¤Î clobber ’¥¿’¡¼’¥²’¥Ã’¥È’¤Ë’ÄÉ’²Ã’¤µ’¤ì’¤ë
  # [<b><em>:reinstaller_base</em></b>]
  #   ’¥¿’¥¤’¥à’¥¹’¥¿’¥ó’¥×’¤Ë’´Ø’¤ï’¤é’¤º’¥¤’¥ó’¥¹’¥È’¡¼’¥é’¥Ù’¡¼’¥¹’¤ò’¤Þ’¤Ã’¤µ’¤é’¤«’¤é’¥ê’¥Ó’¥ë’¥É’¤¹’¤ë
  #
  # ’Îã:
  #
  #   InstallerBaseTask.new do |installer_base|
  #     installer_base.dir = "tmp"
  #     installer_base.mirror = "http://www.debian.or.jp/debian"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "sarge"
  #   end
  #
  # ’ºî’À®’¤¹’¤ë InstallerBaseTask ’¤Ë’¤Ï’¥Ç’¥Õ’¥©’¥ë’¥È’¤Î’Ì¾’Á°’°Ê’³°’¤Ë’¼«’Ê¬’¤Î’¹¥’¤­’¤Ê’Ì¾’Á°’¤ò
  # ’¤Ä’¤±’¤ë’¤³’¤È’¤â’¤Ç’¤­’¤ë’¡£
  #
  #   InstallerBaseTask.new(:installer_base_woody) do |installer_base|
  #     installer_base.dir = "tmp"
  #     installer_base.mirror = "http://www.debian.or.jp/debian"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "woody"
  #   end
  # 
  # ’¤³’¤Î’¾ì’¹ç’¡¢<em>:installer_base_woody</em>, :clobber_<em>installer_base_woody</em>, 
  # :re<em>installer_base_woody</em> ’¤È’¤¤’¤¦’Ì¾’Á°’¤Î’¥¿’¥¹’¥¯’¤¬’À¸’À®’¤µ’¤ì’¤ë’¡£
  #
  class InstallerBaseTask < TaskLib
    # ’¥¤’¥ó’¥¹’¥È’¡¼’¥é’¥Ù’¡¼’¥¹’ºî’À®’¥¿’¥¹’¥¯’¤Î’Ì¾’Á° (’¥Ç’¥Õ’¥©’¥ë’¥È: :installer_base )
    attr_accessor :name
    # ’¥¤’¥ó’¥¹’¥È’¡¼’¥é’¥Ù’¡¼’¥¹’¤ò’ºî’À®’¤¹’¤ë’¥Ç’¥£’¥ì’¥¯’¥È’¥ê’¤Ø’¤Î’¥Ñ’¥¹ 
    # (’¥Ç’¥Õ’¥©’¥ë’¥È: '/var/lib/lucie/installer-base/' )
    attr_accessor :dir
    # Debian ’¤Î’¥ß’¥é’¡¼’¤Î URI (’¥Ç’¥Õ’¥©’¥ë’¥È: http://www.debian.or.jp/debian)
    attr_accessor :mirror
    # ’¥¤’¥ó’¥¹’¥È’¡¼’¥é’¥Ù’¡¼’¥¹’¤Î’¥Ç’¥£’¥¹’¥È’¥ê’¥Ó’¥å’¡¼’¥·’¥ç’¥ó (’¥Ç’¥Õ’¥©’¥ë’¥È: nil)
    attr_accessor :distribution
    # ’¥¤’¥ó’¥¹’¥È’¡¼’¥é’¥Ù’¡¼’¥¹’¤Î’¥Ç’¥£’¥¹’¥È’¥ê’¥Ó’¥å’¡¼’¥·’¥ç’¥ó’¤Î’¥Ð’¡¼’¥¸’¥ç’¥ó (’¥Ç’¥Õ’¥©’¥ë’¥È: nil)
    attr_accessor :distribution_version
    
    # InstallerBase ’¥¿’¥¹’¥¯’¤ò’ºî’À®’¤¹’¤ë’¡£’¥Ç’¥Õ’¥©’¥ë’¥È’¤Î’Ì¾’Á°’¤Ï +installer_base+
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
        debootstrap_option = "--arch i386 --exclude=#{exclude_packages.join(',')}"
        puts "Executing debootstrap. This may take a long time."
        sh_log( %{yes '' | LC_ALL=C debootstrap #{debootstrap_option} #{@distribution_version} #{@dir} #{@mirror} 2>&1}, sh_option ) do |rd|
          line_length = 0
          while (rd.gets)
            line = $_.chomp
            case line
            when /^I: /
              STDERR.print ' ' * line_length, "\r"
              STDERR.print line, "\r"
              line_length = line.length
              logger.debug line
            when /^E: /
              logger.error line 
              raise DebootstrapExecutionError, line
            else
              logger.warn line 
            end
          end
        end
        sh %{chroot #{@dir} apt-get clean}, sh_option
        rm_f File.join(@dir, '/etc/resolv.conf'), sh_option
        puts "Creating #{installer_base_target}."
        sh %{tar -l -C #{@dir} -cf - --exclude #{File.join('var/tmp', target_fname)} . | gzip > #{installer_base_target}}, sh_option       
      end
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
