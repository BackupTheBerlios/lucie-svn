#
# $Id: install-packages.rb 762 2005-07-22 08:40:17Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 762 $
# License::  GPL2

module InstallPackages
  module Command
    class AptitudeR < AbstractCommand
      public
      def commandline
        package_list = @list['aptitude-r'].join(' ')
        return %{#{root_command} aptitude -r #{APT_OPTION} install #{package_list}}
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
