#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

# TODO: preload, preloadrm オプション 

module InstallPackages
  module Command
    class Install < AbstractCommand
      public
      def commandline
        # XXX do not execute 'apt-get clean' always
        return( preload_commandline +
                  [%{#{root_command} apt-get #{APT_OPTION} --force-yes --fix-missing install #{short_list}},
                  %{#{root_command} apt-get clean}] +
                  preloadrm_teardown_commandline)
      end

      private
      def preload_commandline
        return (@preload + @preloadrm).map do |each|
          if URI.regexp(%w(file))=~ each[:url]
            file = URI.parse(each[:url]).path
            %{cp #{File.join('/etc/lucie/', file)} #{File.join('/tmp/target/', each[:directory])}}
          else
            %{wget -nv -P#{File.join('/tmp/target/', each[:directory])} #{each[:url]}}
          end 
        end
      end
      
      private
      def preloadrm_teardown_commandline
        return @preloadrm.map do |each|
          basename = File.basename(URI.parse(each[:url]).path)
          %{rm #{File.join('/tmp/target/', each[:directory], basename)}}
        end
      end

      private
      def short_list
        return @list[0..MAX_PACKAGE_LIST].join(' ')
      end
    end
  end
end

# install コマンド
def install( &block )
  install_command = InstallPackages::Command::Install.new
  block.call( install_command )
  InstallPackages::App.register install_command
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
