#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

spec = LMP::Specification.new do |spec|
  spec.name = "lmp-grub"
  spec.version = "0.0.2"
  spec.maintainer = 'Hideo NISHIMURA <nish@matsulab.is.titech.ac.jp>'
  spec.short_description = '[Lucie Meta Package] grub'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
A Lucie Meta Package which setups grub.
  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'data/lmp/grub'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
