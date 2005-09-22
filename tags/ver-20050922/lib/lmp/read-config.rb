#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module LMP
  # メタパッケージの packages ファイルパーズ用クラス
  class ReadConfig
    public
    def initialize
      @install = false
      @packages_install = []
      @packages_remove = []
    end

    public
    def read( fileNameString )
      File.open( fileNameString, 'r' ).each_line do |each|
        case each
        when comment
          next
        when packages_install_directive
          @install = true
          next
        when packages_remove_directive
          @install = false
          next
        when /(\S+)/
          package = $1
          if @install 
            if /(\S+)\-\Z/=~ package
              @packages_remove.push $1
            else
              @packages_install.push package
            end
          else
            @packages_remove.push package
          end
        end
      end
    end

    public
    def packages
      return {:install => @packages_install, :remove => @packages_remove }
    end

    private
    def comment
      return /\A#.*/
    end

    private
    def packages_install_directive
      return /\APACKAGES\s+install\s*/
    end

    private
    def packages_remove_directive
      return /\APACKAGES\s+remove\s*/
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
