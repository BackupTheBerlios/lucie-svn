#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


require 'install-packages/command'


module InstallPackages
  class CleanCommand
    include Command


    def initialize aptget
      @aptget = aptget
    end


    def execute dryRun = false
      @aptget.clean dryRun
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
