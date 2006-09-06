#
# $Id: spec.rb 926 2006-09-06 ogata $
#


spec = LMP::Specification.new do |spec|
  spec.name = "lmp-mail" 
  spec.version = "0.0.1" 
  spec.maintainer = 'Yasuhiko OGATA <ogata@matsulab.is.titech.ac.jp>'
  spec.short_description = '[Lucie Meta Package] mail'
  spec.extended_description = <<-EXTENDED_DESCRIPTION
A Lucie Meta Package which setups mailx and postfix.
  EXTENDED_DESCRIPTION
end

lmp_package_task = Rake::LMPPackageTask.new( spec ) do |pkg|
  pkg.package_dir = 'data/lmp/mail'
  pkg.need_deb = true
end
