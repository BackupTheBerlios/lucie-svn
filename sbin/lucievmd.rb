#!/usr/bin/ruby
#
# $Id: deft.rb 341 2005-02-26 17:08:19Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 341 $
# License::  GPL2

require 'socket'
require 'English'

resource = { '#nodes upperbound' => 64,
             'HDD size upperbound' => 4,
             'memory size upperbound' => 640,
             'vm' => 'xen, colinux, vmware',
             'distro' => 'Debian (woody), Debian (sarge), redhat7,3'
           }

port = (ARGV[0] || 5555).to_i
lucievmd = TCPServer.open( 'localhost', port )
addr = lucievmd.addr
addr.shift
printf( "server is on %s\n", addr.join(":"))

loop do 
  Thread.start( lucievmd.accept ) do |socket|
  print( socket, " is acepted\n" )
  while socket.gets
    case $LAST_READ_LINE
    when /^GET (.*)$/ && resource[$1]
      socket.puts '0 ' + resource[$1]
    else
      socket.puts "10 unknown variable #{$1}"
    end
  end
  print( socket, "is gone\n" )
  socket.close
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: