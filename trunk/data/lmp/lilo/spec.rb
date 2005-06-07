#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# lilo によるブート処理をセットアップするための Lucie メタパッケージ
#
#--
# TODO: lilo 各種オプションを priority low な質問として追加
#++
#
# Author::   Yasuhito TAKAMIYA (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

spec = LMP::Specification.new do |spec|
  spec.name = "lmp-lilo"
  spec.version = "0.0.2-1"
  spec.maintainer = 'Yasuhito TAKAMIYA <takamiya@matsulab.is.titech.ac.jp>'
  spec.short_description = '[Lucie Meta Package] lilo'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
A Lucie Meta Package which setups lilo.
  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'data/lmp/lilo'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
