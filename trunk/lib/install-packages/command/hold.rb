#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module InstallPackages
  module Command
    class Hold < AbstractCommand
      public
      def commandline
        return @list.map do |each|
          %{echo #{each} hold | #{root_command} dpkg --set-selections}
        end
      end
    end 
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
