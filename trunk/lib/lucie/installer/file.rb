#
# $Id: command-line-options.rb 557 2005-04-13 07:05:05Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision: 557 $
# License::  GPL2

require 'find'
require 'fileutils'

[installer_resource.name, host_group_resource.name, host_resource.name].each do |file_name|
  Find::find($file_dir) do |each|
    if FileTest.file?( each ) and File.basename( each ) == file_name
      target_file = File.join($lucie_root, File.dirname(each[$file_dir.length..-1]))
      target_directory = File.dirname(target_file)
      unless FileTest.exists?( target_directory )
        FileUtils.mkdir_p( target_directory, :verbose => true )
      end
      FileUtils.cp( each, target_file, :verbose => true, :preserve => true )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
