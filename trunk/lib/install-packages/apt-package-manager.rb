#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


module InstallPackages
  module AptPackageManager
    def apt_option
      return %{-y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"}.split( ' ' )
    end
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
