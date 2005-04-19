spec = LMP::Specification.new do |spec|
  spec.name = "lmp-default"
  spec.version = "0.0.1-1"
  spec.maintainer = 'Yasuhito TAKAMIYA <takamiya@matsulab.is.titech.ac.jp>'
  spec.short_description = '[メタパッケージ] default'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
  Included packages:

   o FIXME

  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'test/lmp/build/default'
  pkg.need_deb = true
end
