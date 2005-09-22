#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module InstallPackages
  module Command
    class Clean < AbstractCommand
      public
      def commandline
        return %{#{root_command} apt-get clean}
      end
    end
  end
end

# clean コマンド
def clean
  clean_command = InstallPackages::Command::Clean.new
  InstallPackages::App.register clean_command
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
