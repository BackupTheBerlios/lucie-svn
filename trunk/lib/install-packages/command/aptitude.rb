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
        return [%{#{root_command} aptitude #{APT_OPTION} install #{short_list}}, 
          %{#{root_command} apt-get clean}]
      end

      # XXX: Install と重複
      private
      def short_list
        return @list[0..MAX_PACKAGE_LIST].join(' ')
      end
    end
  end
end

# aptitude コマンド
def aptitude( &block )
  aptitude_command = InstallPackages::Command::Aptitude.new
  block.call( aptitude_command )
  InstallPackages::App.register aptitude_command
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
