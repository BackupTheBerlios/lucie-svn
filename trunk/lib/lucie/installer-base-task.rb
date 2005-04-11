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
  # �����󒥹��Ȓ����钤Β�ْ�������������ƒ�����Ӓ�뒥ɒ����뒥������������������뒡�
  #
  # InstallerBaseTask ��ϒ����Β����������Ò�Ȓ�����������:
  #
  # [<b><em>installer_base</em></b>]
  #   InstallerBase �����������Β�ᒥ���󒥿������
  # [<b><em>:clobber_installer_base</em></b>]
  #   �����ْ�ƒ�Β����󒥹��Ȓ����钥ْ�������ؒϢ��Ւ�������뒤�Ò����뒡�
  #   �����Β����������Ò�Ȓ�ϒ���ư�Ū��˒�ᒥ����� clobber �����������Ò�Ȓ�˒�ɒ�Ò����쒤�
  # [<b><em>:reinstaller_base</em></b>]
  #   ������������������ג�˒�ؒ�钤������󒥹��Ȓ����钥ْ��������ޒ�Ò����钤���钥꒥Ӓ�뒥ɒ�����
  #
  # ���:
  #
  #   InstallerBaseTask.new do |installer_base|
  #     installer_base.dir = "tmp"
  #     installer_base.mirror = "http://www.debian.or.jp/debian"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "sarge"
  #   end
  #
  # ����������� InstallerBaseTask ��˒�ϒ�ǒ�Ւ����뒥Ȓ�Β̾�����ʒ����˒���ʬ��Β�������ʒ̾������
  # ��Ē����뒤���Ȓ�⒤ǒ����뒡�
  #
  #   InstallerBaseTask.new(:installer_base_woody) do |installer_base|
  #     installer_base.dir = "tmp"
  #     installer_base.mirror = "http://www.debian.or.jp/debian"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "woody"
  #   end
  # 
  # �����Β�쒹璡�<em>:installer_base_woody</em>, :clobber_<em>installer_base_woody</em>, 
  # :re<em>installer_base_woody</em> ��Ȓ������̾�����Β����������������������쒤뒡�
  #
  class InstallerBaseTask < TaskLib
    # �����󒥹��Ȓ����钥ْ���������������������Β̾��� (��ǒ�Ւ����뒥�: :installer_base )
    attr_accessor :name
    # �����󒥹��Ȓ����钥ْ����������������뒥ǒ����쒥���Ȓ�꒤ؒ�Β�ђ�� 
    # (��ǒ�Ւ����뒥�: '/var/lib/lucie/installer-base/' )
    attr_accessor :dir
    # Debian ��Β�ߒ�钡���� URI (��ǒ�Ւ����뒥�: http://www.debian.or.jp/debian)
    attr_accessor :mirror
    # �����󒥹��Ȓ����钥ْ�������Β�ǒ�������Ȓ�꒥Ӓ�咡������璥� (��ǒ�Ւ����뒥�: nil)
    attr_accessor :distribution
    # �����󒥹��Ȓ����钥ْ�������Β�ǒ�������Ȓ�꒥Ӓ�咡������璥�Β�В�������璥� (��ǒ�Ւ����뒥�: nil)
    attr_accessor :distribution_version
    
    # InstallerBase ��������������������뒡���ǒ�Ւ����뒥Ȓ�Β̾������ +installer_base+
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
