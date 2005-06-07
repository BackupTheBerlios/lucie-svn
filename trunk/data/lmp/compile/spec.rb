#
# $Id$
#
# コンパイル環境 (コンパイラ、デバッガ、各種ツール、ドキュメント類) を
# セットアップするための Lucie メタパッケージ。
#
# Author::   Yasuhito TAKAMIYA (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

spec = LMP::Specification.new do |spec|
  spec.name = "lmp-compile"
  spec.version = "0.0.2-1"
  spec.maintainer = 'Yasuhito TAKAMIYA <takamiya@matsulab.is.titech.ac.jp>'
  spec.short_description = '[Lucie Meta Package] compile'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
A Lucie Meta Package which setups compilation environment (compilers,
debbugers, tools, documents).
  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'data/lmp/compile'
  pkg.need_deb = true
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
