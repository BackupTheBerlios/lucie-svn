#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


require 'install-packages/command'
require 'popen3/shell'


module InstallPackages
  class AptitudeRCommand
    include Command


    def initialize aptitude
      @aptitude = aptitude
    end


    def execute dryRun = false
      @aptitude.install_with_recommends dryRun
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
