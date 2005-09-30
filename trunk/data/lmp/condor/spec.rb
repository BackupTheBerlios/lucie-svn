#
# $Id$
#
# lilo によるブート処理をセットアップするための Lucie メタパッケージ
#
#--
# TODO: lilo 各種オプションを priority low な質問として追加
#++
#
# Author::   Yasuhito TAKAMIYA (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

spec = LMP::Specification.new do |spec|
  spec.name = "lmp-condor"
  spec.version = "0.0.1-1"
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
