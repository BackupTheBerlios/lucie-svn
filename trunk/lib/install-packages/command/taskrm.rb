#
# $Id: install-packages.rb 764 2005-07-22 08:46:38Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 764 $
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
