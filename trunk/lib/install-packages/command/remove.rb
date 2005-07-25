#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module InstallPackages
  module Command
    class Remove < AbstractCommand
      public
      def commandline
        package_list = @list.join(' ')
        return %{#{root_command} apt-get --purge remove #{package_list}}
      end
    end
  end
end

# remove コマンド
def remove( packageList )
  remove_command = InstallPackages::Command::Remove.new( packageList )
  InstallPackages::App.register remove_command
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
