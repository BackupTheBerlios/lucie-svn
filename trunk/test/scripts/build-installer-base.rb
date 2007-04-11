#!/usr/bin/env ruby
#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


$LOAD_PATH.unshift( '../../lib' ) if __FILE__ =~ /\.rb$/


require 'lucie/installer-base-task'


Rake::InstallerBaseTask.new do | task |
  task.kernel_package = '/usr/lib/fai/kernel/linux-image-2.6.17-fai-kernels_1_i386.deb'
  task.include = [ 'lv' ]
  task.target_directory = '/tmp/debootstrap'
  task.mirror = 'http://ring.asahi-net.or.jp/archives/linux/debian/debian/'
  task.distribution = 'debian'
  task.suite = 'sarge'
  task.http_proxy = 'http://proxy.spf.cl.nec.co.jp:3128'
end


Task[ 'reinstaller_base' ].invoke
