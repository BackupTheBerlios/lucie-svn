#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'
require 'rake/tasklib'
require 'lucie/logger'
require 'lucie/command-line-options'

module Rake
  #
  # インストーラのベースシステムをビルドするタスクを作成する。
  #
  # InstallerBaseTask は次のターゲットを作成する:
  #
  # [<b><em>installer_base</em></b>]
  #   InstallerBase タスクのメインタスク
  # [<b><em>:clobber_installer_base</em></b>]
  #   すべてのインストーラベース関連ファイルを消去する。
  #   このターゲットは自動的にメインの clobber ターゲットに追加される
  # [<b><em>:reinstaller_base</em></b>]
  #   タイムスタンプに関わらずインストーラベースをまっさらからリビルドする
  #
  # 例:
  #
  #   InstallerBaseTask.new do |installer_base|
  #     installer_base.dir = "tmp"
  #     installer_base.mirror = "http://www.debian.or.jp/debian"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "sarge"
  #   end
  #
  # 作成する InstallerBaseTask にはデフォルトの名前以外に自分の好きな名前を
  # つけることもできる。
  #
  #   InstallerBaseTask.new(:installer_base_woody) do |installer_base|
  #     installer_base.dir = "tmp"
  #     installer_base.mirror = "http://www.debian.or.jp/debian"
  #     installer_base.distribution = "debian"
  #     installer_base.distribution_version = "woody"
  #   end
  # 
  # この場合、<em>:installer_base_woody</em>, :clobber_<em>installer_base_woody</em>, 
  # :re<em>installer_base_woody</em> という名前のタスクが生成される。
  #
  class InstallerBaseTask < TaskLib
    # インストーラベース作成タスクの名前 (デフォルト: :installer_base )
    attr_accessor :name
    # インストーラベースを作成するディレクトリへのパス 
    # (デフォルト: '/var/lib/lucie/installer-base/' )
    attr_accessor :dir
    # Debian のミラーの URI (デフォルト: http://www.debian.or.jp/debian)
    attr_accessor :mirror
    # インストーラベースのディストリビューション (デフォルト: nil)
    attr_accessor :distribution
    # インストーラベースのディストリビューションのバージョン (デフォルト: nil)
    attr_accessor :distribution_version
    
    # InstallerBase タスクを作成する。デフォルトの名前は +installer_base+
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