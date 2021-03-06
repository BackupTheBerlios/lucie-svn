#!/usr/bin/env ruby
#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


$LOAD_PATH.unshift( '../../lib' ) if __FILE__ =~ /\.rb$/


require 'lucie/nfsroot-task'


Rake::NfsrootTask.new do | task |
  task.target_directory = '/tmp/nfsroot'
  task.mirror = 'http://ring.asahi-net.or.jp/archives/linux/debian/debian/'
  task.distribution = 'debian'
  task.suite = 'sarge'
  task.kernel_package = '/usr/lib/fai/kernel/linux-image-2.6.17-fai-kernels_1_i386.deb'
end


Task[ 'nfsroot' ].invoke
