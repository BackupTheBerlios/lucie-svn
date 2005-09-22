#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module InstallPackages
  module Command
    class Taskinst < AbstractCommand
      public
      def commandline
        return @list.map do |each|
          %{#{root_command} tasksel -n install #{each}}
        end
      end
    end
  end
end

# taskinst コマンド
def taskinst( packageList )
  taskinst_command = InstallPackages::Command::Taskinst.new( packageList )
  InstallPackages::App.register taskinst_command
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
