# $Id$
#
# Author:: Yasuhito TAKAMIYA <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $Revision$
# License::  GPL2
#
#--
# TODO:
# * RPM support.
#++

module Depends
  VERSION = '0.0.2'.freeze
  STATUS  = '/var/lib/dpkg/status'.freeze
end

require 'depends/cache'
require 'depends/dependency'
require 'depends/package'
require 'depends/pool'

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
