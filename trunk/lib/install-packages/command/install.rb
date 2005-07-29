#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

# TODO: preload, preloadrm オプション 

module InstallPackages
  module Command
    class Install < AbstractCommand
      public
      def commandline
        # XXX do not execute 'apt-get clean' always
        return( preload_commandline +
                  [%{#{root_command} apt-get #{APT_OPTION} --force-yes --fix-missing install #{short_list}},
                  %{#{root_command} apt-get clean}] +
                  preloadrm_teardown_commandline)
      end
    end
  end
end

# install コマンド
def install( packageList=[], &block )
  install_command = InstallPackages::Command::Install.new
  if block_given?
    block.call( install_command )
  else
    install_command.list = packageList
  end
  InstallPackages::App.register install_command
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
