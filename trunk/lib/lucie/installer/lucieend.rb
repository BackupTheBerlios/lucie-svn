#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

puts "Press <RETURN> to reboot."
STDIN.gets
Dir.chdir('/')
sh %{sync}
sh %{killall -q sshd} rescue nil
sh %{umount #{target('proc')}}
sh %{umount -ar} rescue nil
exec %{reboot -dfi}

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
