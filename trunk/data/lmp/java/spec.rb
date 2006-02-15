#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Hideo Nishimura (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

# ------------------------- LMP ‚Ì’è‹`.

spec = LMP::Specification.new do |spec|
  spec.name = "lmp-java"
  spec.version = "0.1.1"
  spec.maintainer = 'Hideo Nishimura <nish@matsulab.is.titech.ac.jp>'
  spec.short_description = '[Metapackage] Java'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
  Included packages:
  A Lucie Meta Package which setups Java runtime environment.
  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'data/lmp/java'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
