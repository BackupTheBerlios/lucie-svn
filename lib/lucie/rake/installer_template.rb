#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake'

# �ȉ��̃O���[�o���ϐ���ݒ�̂���
# $distro = 'woody'
# $template_root_path = 'C:/tmp'
# $template_lucie_directory_path = $template_root_path + "/lucie/"

desc "�C���X�g�[���̃e���v���[�g���쐬����"
task :installer_template => [:installer_template_message]

if FileTest.directory?($template_lucie_directory_path)
  task :installer_template => [:installer_template_message, :kill_old_template_lucie_directory, :create_base]
else
  task :installer_template => [:installer_template_message, :create_base]
end

task :installer_template_message do
  puts "*** STEP 1: Creating a template for Lucie installer images ***"
  puts "A template for Lucie installer images will be created in #{$template_lucie_directory_path}."
  puts "This operation can take a long time and will need approximately 100MB disk spce in #{$template_lucie_directory_path}."
end

desc "�Â� Lucie �̃e���v���[�g�f�B���N�g��������"
task :kill_old_template_lucie_directory # => [:kill_old_template_lucie_directory_message, :unmount_pts, :cleanup_installer_rootfs] 

#
#task :remove_old_template_lucie_directory_message do
#  puts "#{$template_root_path} already exists. Removing #{$template_root_path}."
#end
#
#desc "pts �f�o�C�X���A���}�E���g����"
#task :unmount_pts do
#  puts "Unmounting /dev/pts directory..."
#  sh "umount #{$template_root_path}/dev/pts" unless /mswin32\Z/=~ RUBY_PLATFORM
#  puts "DONE"
#end
#
#task :cleanup_installer_rootfs do
#  puts "Cleaning up installer template root filesystem..."
#  if (/mswin32\Z/=~ RUBY_PLATFORM)
#    # FIXME : Windows �̃V�F���ŏ����H
#    # Ruby �� API �݂̂ŏ����A�ꍇ�킯���Ȃ����H
#  else 
#    sh "rm -rf #{$template_root_path}/.??* #{$template_root_path}/*"
#    # also remove files NFSROOT/.? but not . and ..
#    sh "find #{$template_root_path} ! -type d -xdev -maxdepth 1 | xargs -r rm -f"
#  end
#  puts "DONE"
#end
#
#desc "�e���v���[�g�� Lucie �f�B���N�g�����쐬"
#directory $template_lucie_directory_path
#
desc "�e���v���[�g�̃x�[�X���쐬����"
task :create_base # => [$template_lucie_directory_path] do
#  if FileTest.exists?( template_basetgz_path($distro) )
#    @exec_mediator.command( "tar -C #{$template_root_path} -xzvf #{template_basetgz_path($distro)}" )
#  elsif @global_option.pkg_dir
#    if /woody/=~ $distro # FIXME
#      call_debootstrap
#      Sys::Apt.clean( {:root_path => root_path( $distro ), :apt_option => { 'APT::Get::Assume-Yes' => 'true' }})
#      
#      puts "Creating a basesystem tarball on %s:\n" # FIXME
#      sh "tar --directory #{$template_root_path} --create --gzip --verbose --file #{template_basetgz_path($distro)} ."
#    end
#  end
#end
#
#desc "debootstrap �����s"
#file "debootstrap" => ["debootstrap �����s�����^�C���X�^���v"] do
#  puts "Creating installer root filesystem for `XXX' installer using debootstrap:" # FIXME
#  sh "yes '' | #{debootstrap_cmd($distro, @global_option.pkg_dir)}" # FIXME
#end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
