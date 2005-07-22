#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module InstallPackages
  module Command
    class Taskrm < AbstractCommand
      public
      def commandline
        return @list['taskrm'].map do |each|
          %{#{root_command} tasksel -n remove #{each}}
        end
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
