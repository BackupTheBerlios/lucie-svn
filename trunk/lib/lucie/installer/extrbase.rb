#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

base_tgz = File.join( '/var/tmp', installer_resource.distribution + '_' + installer_resource.distribution_version + '.tgz')
sh( %{gzip -dc #{base_tgz} | tar -C #{$lucie_root} -xpf -}, $sh_option )

# now we can copy fstab
fs = target('etc/fstab')
sh( %{[ -f #{fs} ] && mv #{fs} #{fs}.old}, $sh_option )
cp( File.join( $logdir, 'fstab' ), fs, {:preserve => true}.merge($sh_option) )

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
