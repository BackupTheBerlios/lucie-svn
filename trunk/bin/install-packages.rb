#!/usr/bin/ruby1.8
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'English'
require 'install-packages/abstract-command'
require 'install-packages/app'
require 'install-packages/command/aptitude'
require 'install-packages/command/aptitude-r'
require 'install-packages/command/clean'
require 'install-packages/command/dselect-upgrade'
require 'install-packages/command/hold'
require 'install-packages/command/install'
require 'install-packages/command/remove'
require 'install-packages/command/taskinst'
require 'install-packages/command/taskrm'
require 'install-packages/options'
require 'uri'

if __FILE__ == $PROGRAM_NAME
  InstallPackages::App.instance.main
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
