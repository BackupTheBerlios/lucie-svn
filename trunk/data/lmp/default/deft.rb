#
# $Id: lucie_vm_template.rb 395 2005-03-10 08:28:02Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 395 $
# License::  GPL2

require 'deft'
include Deft

# ------------------------- Welcome メッセージ

template( 'lucie-client/default/hello' ) do |template|
  template.template_type = 'note'
  template.short_description = 'Welcome to lmp-default setup wizard.'
  template.extended_description = <<-DESCRIPTION
  Click OK
  DESCRIPTION
end

question( 'lucie-client/default/hello' => proc do 
            timezones = Dir.chdir( '/usr/share/zoneinfo' ) do 
              (Dir.glob('*')+Dir.glob('*/*') - ['localtime', 'zone.tab']).sort.join(', ')
            end
            subst 'lucie-client/default/timezone', 'timezones', timezones
            'lucie-client/default/timezone' 
          end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
  question.first_question = true
end

# ------------------------- Timezone の設定

template( 'lucie-client/default/timezone' ) do |template|
  template.template_type = 'select'
  template.choices = '${timezones}'
  template.short_description = 'Configure timezone'
  template.extended_description = <<-DESCRIPTION
  Please select timezone.
  DESCRIPTION
end

question( 'lucie-client/default/timezone' => 'lucie-client/default/utc' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- UTC の設定

template( 'lucie-client/default/utc' ) do |template|
  template.template_type = 'boolean'
  template.short_description = 'Configure UTC'
  template.extended_description = <<-DESCRIPTION
  Does your hardware clock set to UTC?
  DESCRIPTION
end

question( 'lucie-client/default/utc' => proc do
            require 'lucie/installer'
            include Lucie::Installer
            modules = Dir.chdir( "/lib/modules/#{installer_resource.kernel_version}" ) do 
              Dir.glob('**/*.o').map! { |each|
                File.basename( each, '.o' )
              }.sort.join(', ')
            end
            subst 'lucie-client/default/modules', 'modules', modules
            'lucie-client/default/modules' 
          end ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

# ------------------------- Module の設定

template( 'lucie-client/default/modules' ) do |template|
  template.template_type = 'multiselect'
  template.choices = '${modules}'
  template.short_description = 'Configure modules'
  template.extended_description = <<-DESCRIPTION
  Select modules insmoded at boot time.
  DESCRIPTION
end

question( 'lucie-client/default/modules' ) do |question|
  question.priority = Question::PRIORITY_MEDIUM
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
