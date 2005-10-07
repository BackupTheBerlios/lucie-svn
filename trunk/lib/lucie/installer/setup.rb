#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

# TODO: timeserver or ntpserver のサポート

# create two virtual terminals
begin
  sh %{openvt -c2 /bin/bash}, $sh_option
  sh %{openvt -c3 /bin/bash}, $sh_option
rescue 
  STDERR.puts "WARNING: Could not open virtual terminals."
end

# TODO: sshd のサポート

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
