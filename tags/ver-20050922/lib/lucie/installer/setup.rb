#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

# TODO: timeserver or ntpserver $B$N%5%]!<%H(B

# create two virtual terminals
sh %{openvt -c2 /bin/bash}, $sh_option
sh %{openvt -c3 /bin/bash}, $sh_option

# TODO: sshd $B$N%5%]!<%H(B

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
