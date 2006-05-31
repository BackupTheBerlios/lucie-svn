#
# $Id$
#
# condor ´Ä¶­¤ò¥»¥Ã¥È¥¢¥Ã¥×¤¹¤?¿¤á¤Î Lucie ¥á¥¿¥Ñ¥Ã¥±¡¼¥¸
#
#--
# XXX: condor central server ¤ÎÌ¾Á°¤Î¼ÁÌ?#++
#
# Author::   Yasuhito TAKAMIYA (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

spec = LMP::Specification.new do |spec|
  spec.name = "lmp-condor"
  spec.version = "0.0.3"
  spec.maintainer = 'Yasuhito TAKAMIYA <takamiya@matsulab.is.titech.ac.jp>'
  spec.short_description = '[Lucie Meta Package] condor'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
A Lucie Meta Package which setups condor.
  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'data/lmp/condor'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
