#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'

desc "インストーラのテンプレートを作成する"
task :installer_template => [:installer_template_message]

if FileTest.directory?($template_lucie_directory)
  task :installer_template => [:installer_template_message, :kill_old_template_lucie_directory, :create_base]
else
  task :installer_template => [:installer_template_message, :create_base]
end

task :installer_template_message do
  puts "*** STEP 1: Creating a template for Lucie installer images ***"
  puts "A template for Lucie installer images will be created in #{$template_directory}."
  puts "This operation can take a long time and will need approximately 100MB disk spce in #{$template_directory}."
end

desc "古い Lucie のテンプレートディレクトリを消去"
task :kill_old_template_lucie_directory # => [:kill_old_template_lucie_directory_message, :unmount_pts, :cleanup_installer_rootfs] 

#
#task :remove_old_template_lucie_directory_message do
#  puts "#{$template_directory} already exists. Removing #{$template_directory}."
#end
#
#desc "pts デバイスをアンマウントする"
#task :unmount_pts do
#  puts "Unmounting /dev/pts directory..."
#  sh "umount #{$template_directory}/dev/pts" unless /mswin32\Z/=~ RUBY_PLATFORM
#  puts "DONE"
#end
#
#task :cleanup_installer_rootfs do
#  puts "Cleaning up installer template root filesystem..."
#  if (/mswin32\Z/=~ RUBY_PLATFORM)
#    # FIXME : Windows のシェルで書く？
#    # Ruby の API のみで書き、場合わけをなくす？
#  else 
#    sh "rm -rf #{$template_directory}/.??* #{$template_directory}/*"
#    # also remove files NFSROOT/.? but not . and ..
#    sh "find #{$template_directory} ! -type d -xdev -maxdepth 1 | xargs -r rm -f"
#  end
#  puts "DONE"
#end
#
#desc "テンプレートの Lucie ディレクトリを作成"
#directory $template_lucie_directory
#
desc "テンプレートのベースを作成する"
task :create_base # => [$template_lucie_directory] do
#  if FileTest.exists?( template_basetgz_path($distro) )
#    @exec_mediator.command( "tar -C #{$template_directory} -xzvf #{template_basetgz_path($distro)}" )
#  elsif @global_option.pkg_dir
#    if /woody/=~ $distro # FIXME
#      call_debootstrap
#      Sys::Apt.clean( {:root_path => root_path( $distro ), :apt_option => { 'APT::Get::Assume-Yes' => 'true' }})
#      
#      puts "Creating a basesystem tarball on %s:\n" # FIXME
#      sh "tar --directory #{$template_directory} --create --gzip --verbose --file #{template_basetgz_path($distro)} ."
#    end
#  end
#end
#
#desc "debootstrap を実行"
#file "debootstrap" => ["debootstrap を実行したタイムスタンプ"] do
#  puts "Creating installer root filesystem for `XXX' installer using debootstrap:" # FIXME
#  sh "yes '' | #{debootstrap_cmd($distro, @global_option.pkg_dir)}" # FIXME
#end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
