#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

# TODO: preload, preloadrm オプション 

module InstallPackages
  module Command
    class AptitudeR < AbstractCommand
      public
      def commandline
        case @list
        when Array
          package_list = @list.join(' ')
        when String
          package_list = @list
        else 
          raise "This shouldn't happen"
        end
        return( preload_commandline +  
                  [%{#{root_command} aptitude -r #{APT_OPTION} install #{package_list}}] +
                  preloadrm_teardown_commandline )
      end
    end
  end
end

# aptitude_r コマンド
def aptitude_r( packageList=[], &block )
  aptitude_r_command = InstallPackages::Command::AptitudeR.new
  if block_given?
    block.call( aptitude_r_command )
  else
    aptitude_r_command.list = packageList
  end
  InstallPackages::App.register aptitude_r_command
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
