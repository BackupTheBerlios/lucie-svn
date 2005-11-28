#
# $Id: spec.rb 926 2005-09-30 07:11:50Z takamiya $
#
# Ganglia �Ķ��򥻥åȥ��åפ��뤿��� Lucie �᥿�ѥå�����
#
#--
# XXX: ganglia trusted_hosts ��̾���μ���
#++
#
# Author::   Hideo NISHIMURA (mailto:nish@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 926 $
# License::  GPL2

spec = LMP::Specification.new do |spec|
  spec.name = "lmp-ganglia"
  spec.version = "0.0.1"
  spec.maintainer = 'Hideo NISHIMURA <nish@matsulab.is.titech.ac.jp>'
  spec.short_description = '[Lucie Meta Package] ganglia'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
A Lucie Meta Package which setups ganglia.
  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'data/lmp/ganglia'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
