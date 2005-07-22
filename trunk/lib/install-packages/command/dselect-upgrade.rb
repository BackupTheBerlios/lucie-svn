#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module InstallPackages
  module Command
    class DselectUpgrade < AbstractCommand
      public
      def initialize( listHash )
        super listHash
        if $dry_run
          @list['dselect-upgrade'].each do |each|
            puts( each[:package] + ' ' + each[:action] )
          end
        else
          File.open( tempfile, 'w' ) do |file|
            @list['dselect-upgrade'].each do |each|
              file.puts( each[:package] + ' ' + each[:action] )
            end
          end
        end
      end

      public
      def commandline
        return [%{#{root_command} dpkg --set-selections < #{tempfile}},
          %{#{root_command} apt-get #{APT_OPTION} dselect-upgrade},
          %{rm #{tempfile}}]
      end
      
      # TODO: use better uniq filename
      private
      def tempfile
        return %{/tmp/target/tmp/dpkg-selections.tmp}
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
