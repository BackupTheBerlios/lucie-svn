#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2


module Kernel
  def install *packages
    InstallPackages::App.instance.add_command :install, packages
  end


  def remove *packages
    InstallPackages::App.instance.add_command :remove, packages
  end


  def clean *packages
    InstallPackages::App.instance.add_command :clean, packages
  end


  def aptitude *packages
    InstallPackages::App.instance.add_command :aptitude, packages
  end


  def aptitude_r *packages
    InstallPackages::App.instance.add_command :aptitude_r, packages
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
