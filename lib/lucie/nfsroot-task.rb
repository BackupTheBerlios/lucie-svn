#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

module Rake
  class NfsrootTask
    attr_accessor :name
    attr_accessor :dir
    attr_accessor :installer_base
    
    # Nfsroot タスクを作成する。
    public
    def initialize( name=:nfsroot ) # :yield: self
      @name = name
      @dir = '/var/lib/lucie/nfsroot/'
      yield self if block_given?
      define
    end
    
    private
    def define
      desc "Build the nfsroot filesytem using #{installer_base}"
      task @name
      
      directory @dir
      task @name => nfsroot_target
      file nfsroot_target do
      end
    end
    
    private
    def nfsroot_target
      return File.join( @dir + 'lucie/timestamp' )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: