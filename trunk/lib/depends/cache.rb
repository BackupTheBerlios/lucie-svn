# =パッケージ間依存情報のキャッシュ管理用クラス定義
#
# $Id: cache.rb,v 1.5 2004/06/30 06:50:19 takamiya Exp $
#
# Author:: Yasuhito TAKAMIYA, <mailto:takamiya@matsulab.is.titech.ac.jp>
# Revision:: $Revision: 1.5 $
# License:: GPL2

module Depends
  # パッケージ間依存情報プール (Pool) のキャッシュ管理用クラス。Pool 
  # の内容のキャッシングを自動的に行うため、生で Pool クラスを扱うのに
  # 比べて高速化される。
  # 
  # _Example_
  #
  #  pool = Depends::Cache.new.pool
  #
  # キャッシュされている Pool オブジェクトがあればそれを使用し、無けれ
  # ば新たに生成しキャッシュする。
  #
  class Cache
    # キャッシュ作成用ディレクトリ
    DEFAULT_CACHE_DIRECTORY = File.expand_path('/var/cache/depends/')
    # キャッシュファイル名
    DEFAULT_CACHE_FILENAME = 'depends.cache'
    # パッケージ間依存情報プール
    attr_reader :pool

    def initialize( cacheDirectoryString=DEFAULT_CACHE_DIRECTORY, 
                    cacheFilenameString=DEFAULT_CACHE_FILENAME )
      @cache_directory = cacheDirectoryString
      @cache_filename = cacheFilenameString
      if cache_exists?
        restore_from_file
      else
	STDERR.puts "cache does not exist, creating..." if $trace
	update_cache
      end
    end

    public
    def inspect #:nodoc:
      return %{<Cache: cachefile='#{cache_filepath}'>}
    end

    private
    def restore_from_file
      if cache_timestamp < status_timestamp
        STDERR.puts "cache is outdated, refreshing..." if $trace
        update_cache
      else
        load_cache
      end
    end

    private
    def cache_exists?
      return FileTest.exist?( cache_filepath )
    end

    private
    def status_timestamp
      return File.stat( STATUS ).mtime
    end

    private
    def cache_timestamp
      return File.stat( cache_filepath ).mtime
    end

    private
    def cache_filepath
      return File.join( @cache_directory, @cache_filename )
    end
    
    private
    def update_cache
      @pool = Pool.new
      File.open( cache_filepath, 'w' ) do |file|
	Marshal.dump @pool, file
      end
    end

    private
    def load_cache
      File.open( cache_filepath, 'r' ) do |file|
	@pool = Marshal.load( file )
      end
    end
  end
end 

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
