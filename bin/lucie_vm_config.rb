#!/usr/bin/ruby1.8
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

require 'lucie/debconf-context'
require 'English'

########
# MAIN #
########

if __FILE__ == $PROGRAM_NAME
  capb 'backup'
  title "Lucie VM のカスタマイズ"
  debconf_context = DebconfContext.new  
  loop do 
    rc = debconf_context.transit
    exit 0 if rc.nil?
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: