#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'fileutils'

module LMP
  class Builder
    public
    def initialize( aSpec )
      @spec = aSpec
    end
    
    # Specification Çå≥Ç… LMP ÇÉrÉãÉhÇ∑ÇÈÅB
    public
    def build
      FileUtils.mkdir_p( @spec.builddir )
      @debian_dir_path = [@spec.builddir, @spec.name, 'debian'].join('/')
      FileUtils.mkdir_p( @debian_dir_path )
      readme_debian
      changelog
      config
      control
      copyright
      postinst
      rules
      templates
      debuild   
    end
    
    # ------------------------- LMP building methods.

    private
    def debuild
      system( "(cd #{@debian_dir_path}; debuild)" )
    end
    
    # ------------------------- Debian package metadata file generator methods.
    
    private
    def readme_debian
      File.open( @debian_dir_path + '/README.Debian', 'w+' ) do |readme_debian|
        readme_debian.print @spec.readme
      end
    end
    
    private 
    def changelog      
      File.open( @debian_dir_path + '/changelog', 'w+' ) do |changelog|
        changelog.print @spec.changelog
      end
    end
    
    private
    def config
      File.open( @debian_dir_path + '/config', 'w+' ) do |config|
        config.print @spec.config
      end
    end
    
    private
    def control
      File.open( @debian_dir_path + '/control', 'w+' ) do |control|
        control.print @spec.control
      end      
    end
    
    private
    def copyright
      File.open( @debian_dir_path + '/copyright', 'w+' ) do |copyright|
        copyright.print @spec.copyright
      end     
    end
    
    private
    def postinst
      File.open( @debian_dir_path + '/postinst', 'w+' ) do |postinst|
        postinst.print @spec.postinst
      end      
    end
    
    private
    def rules
      File.open( @debian_dir_path + '/rules', 'w+' ) do |rules|
        rules.print @spec.rules
      end  
    end
    
    private
    def templates
      File.open( @debian_dir_path + '/templates', 'w+' ) do |templates|
        templates.print @spec.templates
      end  
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: