# = cache.rb - Cache faculty class.
#
# $Id: cache.rb,v 1.5 2004/06/30 06:50:19 takamiya Exp $
#
# Author:: Yasuhito TAKAMIYA, <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $Revision: 1.5 $
# License:: GPL2

module Depends
  # Cache class for dependency object pool.
  class Cache
    DEFAULT_CACHE_DIRECTORY = File.expand_path('/var/cache/depends/')
    DEFAULT_CACHE_FILENAME = 'depends.cache'
    attr :pool

    # Returns a new Cache object.
    #
    # _Example_:
    #  Cache.new.pool #=> aNewPoolObj.
    #
    def initialize( cacheDirectoryString=DEFAULT_CACHE_DIRECTORY, 
                    cacheFilenameString=DEFAULT_CACHE_FILENAME )
      @cache_directory = cacheDirectoryString
      @cache_filename = cacheFilenameString

      # persist/restore object pool
      if cache_exists?
	if cache_timestamp < status_timestamp
	  STDERR.puts "cache is outdated, refreshing..."
	  update_cache
	else
	  load_cache
	end
      else
	STDERR.puts "cache does not exist, creating..."
	update_cache
      end
    end

    public
    def inspect #:nodoc:
      "<Cache: cachefile='#{cache_filepath}'>"
    end

    private
    def cache_exists?
      test(?f, cache_filepath)
    end

    private
    def status_timestamp
      File.stat( STATUS ).mtime
    end

    private
    def cache_timestamp
      File.stat( cache_filepath ).mtime
    end

    private
    def cache_filepath
      @cache_directory + '/' + @cache_filename
    end
    
    private
    def update_cache
      @pool = Depends::Pool.new
      File.open( cache_filepath, 'w' ){ |file|
	Marshal.dump @pool, file
      }
    end

    private
    def load_cache
      File.open( cache_filepath, 'r' ){ |file|
	@pool = Marshal.load( file )
      }
    end
  end
end 

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
