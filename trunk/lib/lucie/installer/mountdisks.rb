#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

fstab = File.join( $logdir, 'fstab' )
raise "No #{fstab} created." unless FileTest.exists?(fstab)

# mount swap space
swaplist = `source #{$diskvar} && echo $SWAPLIST`.strip.split(' ')
swaplist.each do |each|
  sh( %{swapon #{each} && echo "Enable swap device #{each}"}, $sh_option )
end
sh( %{mount2dir #{$lucie_root} #{fstab}}, $sh_option )

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
