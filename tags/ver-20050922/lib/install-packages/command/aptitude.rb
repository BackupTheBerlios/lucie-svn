#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

# TODO: preload, preloadrm オプション 

module InstallPackages
  module Command
    class Aptitude < AbstractCommand
      public
      def commandline
        # XXX do not execute 'apt-get clean' always
        return( preload_commandline + 
                  [%{#{root_command} aptitude #{APT_OPTION} install #{short_list}}, 
                  %{#{root_command} apt-get clean}] +
                  preloadrm_teardown_commandline )
      end
    end
  end
end

# aptitude コマンド
def aptitude( packageList=[], &block )
  aptitude_command = InstallPackages::Command::Aptitude.new
  if block_given?
    block.call( aptitude_command )
  else
    aptitude_command.list = packageList
  end
  InstallPackages::App.register aptitude_command
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
