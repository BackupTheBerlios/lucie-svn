#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

# umount swap space
swaplist = `source #{$diskvar} && echo $SWAPLIST`.strip.split(' ')
swaplist.each do |each|
  sh %{swapoff #{each} && echo "Disable swap device #{each}"}
end
# undo fake of all programs made by fai
`chroot #{$lucie_root} dpkg-divert --list lucie-client | awk '{ print $3}'`.split("\n").each do |each|
  rm_f target(each)
  sh %{chroot #{$lucie_root} dpkg-divert --package lucie-client --rename --remove #{each}}
  # when a diversion was made before the file exists
  sh %{[ -f #{target(each +'.distrib.dpkg-new')} ] && mv #{target(each +'.distrib.dpkg-new')} #{target(each +'.distrib')}} rescue nil
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
