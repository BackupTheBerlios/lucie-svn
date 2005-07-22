#
# $Id: install-packages.rb 762 2005-07-22 08:40:17Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 762 $
# License::  GPL2

module InstallPackages
  module Command
    class Hold < AbstractCommand
      public
      def commandline
        return @list['hold'].map do |each|
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