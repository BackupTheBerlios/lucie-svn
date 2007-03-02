#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


require 'install-packages/aptget'
require 'install-packages/aptitude'
require 'install-packages/command/aptitude'
require 'install-packages/command/aptitude-r'
require 'install-packages/command/clean'
require 'install-packages/command/install'
require 'install-packages/command/remove'
require 'install-packages/invoker'
require 'singleton'


module InstallPackages
  class App
    include Singleton


    attr_accessor :invoker


    def add_command directive, packages
      receiver = receiver_command_table[ directive ][ :receiver ].new( packages )
      command = receiver_command_table[ directive ][ :command ].new( receiver )

      @invoker ||= InstallPackages::Invoker.new
      @invoker.add_command command
    end


    def main option
      @option = option
      begin
        if( @option.version or @option.help )
          exit 0
        end
      end
      config_file.each do | each |
        do_install each
      end
    end


    private


    def receiver_command_table
      return receiver_command_table = {
        :install => { :receiver => InstallPackages::AptGet, :command => InstallPackages::InstallCommand },
        :remove => { :receiver => InstallPackages::AptGet, :command => InstallPackages::RemoveCommand },
        :clean => { :receiver => InstallPackages::AptGet, :command => InstallPackages::CleanCommand },
        :aptitude => { :receiver => InstallPackages::Aptitude, :command => InstallPackages::AptitudeCommand },
        :aptitude_r => { :receiver => InstallPackages::Aptitude, :command => InstallPackages::AptitudeRCommand }
      }
    end


    def config_file
      if @option.config_file
        return [ @option.config_file ]
      else
        # [XXX] デフォルトの設定ファイルをロードさせる
        # return Dir.glob( '/etc/lucie/package/*' )
      end
    end


    def do_install configFile
      require 'install-packages/kernel'
      load configFile
      @invoker.start @option
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
