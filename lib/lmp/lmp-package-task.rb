#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake/packagetask'

module Rake
  class LMPPackageTask < PackageTask
    attr_accessor :lmp_spec
    
    public
    def initialize( aSpecification )
      init( aSpecification )
    end
    
    public
    def init( aSpecification )
      super( aSpecification.name, aSpecification.version )
      @lmp_spec = aSpecification
      @package_files += lmp_spec.files if lmp_spec.files
    end
    
    public
    def define
      super
      task :package => [:lmp]
      task :lmp => ["#{package_dir}/#{lmp_file}"]
      file "#{package_dir}/#{lmp_file}" => [package_dir] + @lmp_spec.files do
        when_writing( 'Creating LMP' ) do
          LMP::Builder.new( @lmp_spec ).build          
        end
      end
    end
    
    private
    def lmp_file
      return "#{package_name}.deb"
    end
    
    private
    def package_name
      "#{@name}_#{@version}_all"
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: