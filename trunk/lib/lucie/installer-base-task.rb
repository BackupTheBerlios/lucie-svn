#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'lucie/command-line-options'
require 'lucie/time-stamp'
require 'rake'
require 'rake/tasklib'

Lucie::update(%q$Id$)

module Rake
  class InstallerBaseTask < TaskLib
    # base ���󥹥ȡ��餬���������ǥ��쥯�ȥ�
    INSTALLER_BASE_DIR = '/var/lib/lucie/installer_base'.freeze

    # base ���󥹥ȡ����̾��
    attr_accessor :name
    # base ���󥹥ȡ���κ����˻��Ѥ�������ǥ��쥯�ȥ�Υե�ѥ�
    attr_accessor :dir
    # debootstrap �μ¹Ԥǻ��Ѥ���� Debian �ߥ顼�����Ф� URI
    attr_accessor :mirror
    # base ���󥹥ȡ�����������ǥ����ȥ�ӥ塼�����
    attr_accessor :distribution
    # base ���󥹥ȡ�����������ǥ����ȥ�ӥ塼�����ΥС������
    attr_accessor :distribution_version
    
    #
    # �ʲ��Τ褦�ˤ��뤳�Ȥǥ��󥹥ȡ��� "my_installer" �Υ١�������
    # �ȡ����������� Task ���������롣
    #
    #  installer_name = 'my_installer'
    #  Rake::InstallerBaseTask.new( installer_name ) do |installer_base|
    #    installer_base.dir = File.join( Rake::InstallerBaseTask::INSTALLER_BASE_DIR, installer_name )
    #    installer_base.mirror = 'http://192.168.152.2:9999/debian'
    #    installer_base.distribution = 'debian'
    #    installer_base.distribution_version = 'sarge'
    #  end
    #
    # �������� Task �ϰʲ����̤� (���󥹥ȡ���̾�� "my_installer" �Ȥ������)��
    # 
    # * _my_installer_: base ���󥹥ȡ���κ���
    # * _clobber_my_installer_: base ���󥹥ȡ���κ��
    # * _remy_installer_: base ���󥹥ȡ���ζ����ƥӥ��
    # 
    public
    def initialize( name=:installer_base ) # :yield: self
      @name = name
      @dir = INSTALLER_BASE_DIR
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
        cleanup_temporary_directory
      end
      
      task :clobber => [paste("clobber_", name)]
      
      directory @dir
      task name => [installer_base_target]
      
      file installer_base_target do
        debootstrap_option = "--arch i386 --exclude=#{exclude_packages.join(',')} --include=ncurses-term,locales"
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
        rm File.join(@dir, '/etc/resolv.conf'), { :force => true }.merge( sh_option )
        locale_gen
        build_installer_base_tarball
        cleanup_temporary_directory
      end
    end

    private
    def build_installer_base_tarball
      info "Creating installer base tarball on #{installer_base_target}."
      sh %{tar -l -C #{@dir} -cf - . | gzip > #{installer_base_target}}, sh_option
    end

    private 
    def cleanup_temporary_directory
      info "Removing debootstrap temporary directory."
      rm_rf @dir, sh_option
    end
    
    # �᥿�ѥå������Ѥ� locale �����
    private
    def locale_gen
      File.open( File.join(@dir, '/etc/locale.gen'), 'w+' ) do |file|
        file.puts "ja_JP.EUC-JP EUC-JP"
        file.puts "en_US ISO-8859-1"
      end
      sh %{chroot #{@dir} locale-gen}, sh_option
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
      return File.join(INSTALLER_BASE_DIR, target_fname)
    end
    
    class DebootstrapExecutionError < ::StandardError; end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
