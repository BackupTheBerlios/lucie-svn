#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'pp'
require 'singleton'

module InstallPackages
  # install-packages �Υ��ץꥱ������󥯥饹
  class App
    include Singleton
    
    @@list = {}

    public
    def self.register( aCommand )
      if @@list[aCommand.class].nil?
        @@list[aCommand.class] = [aCommand]
      else
        @@list[aCommand.class] << aCommand
      end
      return aCommand
    end

    #--
    # XXX /tmp/target �Υѥ��� Lucie �Υ饤�֥�꤫�����
    #++
    private
    def root_command
      return ($LUCIE_ROOT == '/') ? '' : "chroot /tmp/target" 
    end

    # install-packages �Υᥤ��롼����
    public
    def main
      begin
        @options = Options.instance.parse( ARGV )
        exit 0 if (@options.version or @options.help)
      rescue GetoptLong::InvalidOption, GetoptLong::MissingArgument
        exit 1
      end
      if $config_file
        do_install( $config_file )
      else
        # XXX: /etc/lucie �Υѥ��� Lucie �饤�֥�꤫�����
        Dir.glob('/etc/lucie/package/*').each do |each|
          do_install( each )
        end
      end
    end

    private
    def do_install( configFileString )
      load( configFileString )
      do_commands
      clean_exit
    end

    private
    def clean_exit
      # in case of unconfigured packages because of apt errors
      # retry configuration 
      AbstractCommand.execute %{#{root_command} dpkg --configure --pending}
      # check if all went right
      AbstractCommand.execute %{#{root_command} dpkg -C}
      # clean apt cache
      AbstractCommand.execute %{#{root_command} apt-get clean}
    end

    # install, clean ���Υ��ޥ�ɤ�ºݤ˼¹Ԥ���
    #--
    # XXX: ��ե��������
    #++
    private
    def do_commands
      commands.each do |each|
        if (each == Command::Clean) && @@list[each]
          @@list[each].each do |command| command.go end
          next
        end

        # skip if empty list
        next if @@list[each].nil?

        if each == Command::DselectUpgrade
          @@list[each].each do |command| command.go end
          next
        end

        if each == Command::Hold
          @@list[each].each do |command| command.go end
          next
        end

        if( each == Command::Install || each == Command::Aptitude )
          # TODO: �Τ�ʤ��ѥå������� libapt-pkg ��Ĵ�٤�
          @@list[each].each do |command| command.go end
          next
        end

        if( each == Command::Aptitude )
          # TODO: �Τ�ʤ��ѥå������� libapt-pkg ��Ĵ�٤�
          @@list[each].each do |command| command.go end
          next
        end

        if( each == Command::Taskinst )
          @@list[each].each do |command| command.go end
          next
        end

        if( each == Command::Taskrm )
          @@list[each].each do |command| command.go end
          next
        end

        # other types
        @@list[each].each do |command| command.go end
      end
    end

    private
    def commands
      return [Command::Hold, Command::Taskrm, Command::Taskinst,
        Command::Clean, Command::AptitudeR, Command::Aptitude,
        Command::Install, Command::Remove, Command::DselectUpgrade]
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
