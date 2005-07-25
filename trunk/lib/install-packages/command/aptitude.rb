#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module InstallPackages
  module Command
    class Aptitude < AbstractCommand
      public
      def commandline
        # XXX do not execute 'apt-get clean' always
        return [%{#{root_command} aptitude #{APT_OPTION} install #{short_list}}, 
          %{#{root_command} apt-get clean}]
      end

      # XXX: Install ¤È½ÅÊ£
      private
      def short_list
        return @list[0..MAX_PACKAGE_LIST].join(' ')
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
