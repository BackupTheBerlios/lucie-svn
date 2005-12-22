#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

# ------------------------- LMP の定義.

spec = LMP::Specification.new do |spec|
  spec.name = "lmp-xen"
  spec.version = "0.2.0"
  spec.maintainer = 'Hideo Nishimura <nish@matsulab.is.titech.ac.jp>'
  spec.short_description = '[メタパッケージ] XEN'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
  Included packages:
  A Lucie Meta Package which setups Xen VMM environment.
  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'data/lmp/xen'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
