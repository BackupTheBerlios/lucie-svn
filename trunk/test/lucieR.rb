#!/usr/bin/ruby

require 'tempfile'
require 'socket'

$HOSTNAME = `cat /etc/hostname`.chomp
$PORT = 7654

if ARGV.length <= 0
  abort( "missing installer name" )  
end

# インストーラの名前
$INSTALLER = ARGV[ 0 ]

# 設定ファイルのパス
$CONFIG_FILE = "/etc/lucie/#{$INSTALLER}/node.lst"
# NFSRoot ディレクトリのパス
$NFSROOT = "/var/lib/lucie/nfsroot/#{$INSTALLER}/"

# インストールするノードのリスト
$node_list = Array.new

#------------------------------#
#--- 設定ファイルの読み出し ---#
#------------------------------#
begin
  conf_file = open( $CONFIG_FILE, "r" )
rescue
  abort( "missing config file #{$CONFIG_FILE}" )
end
while conf_line = conf_file.gets
  if conf_line.length > 0 && conf_line[ 0 ] != "#"
    $node_list << ( conf_line.chomp ).strip    
  end
end
conf_file.close

# インストールするノード数
$node_number = $node_list.length

#--------------------------#
#--- NFSRoot の書き換え ---#
#--------------------------#
begin
  lucieend_file = open( "#{$NFSROOT}/usr/lib/ruby/1.8/lucie/installer/lucieend.rb", "w" )
rescue
  abort( "missing /usr/lib/ruby/1.8/lucie/installer/lucieend.rb in NFSRoot" )
end

lucieend_file.print <<EOFILE
require 'socket'

hostname = `cat /tmp/target/etc/hostname`.chomp
TCPSocket.open( "#{$HOSTNAME}", #{$PORT} ) { |f|
  f.puts( hostname )
}

server = TCPServer.new( "0.0.0.0", #{$PORT} )
server.accept

Dir.chdir('/')
sh %{sync}
sh %{killall -q sshd} rescue nil
sh %{umount \#{target('proc')}}
sh %{umount -ar} rescue nil

exec %{reboot -dfi}
EOFILE

lucieend_file.close

#----------------------------------#
#--- インストール終了の待ち受け ---#
#----------------------------------#

wait_server = TCPServer.new( "0.0.0.0", $PORT )

client_list = Array.new

$node_number.times{ |number|
  Thread.fork( wait_server.accept ) { |s|
    begin 
      client = ( s.gets ).chomp
      puts "#{client} connected"
      client_list << client
      STDOUT.flush
    ensure
      s.close unless s.closed?  
    end
  }
}

#---------------------#
#--- Reboot の発行 ---#
#---------------------#

sleep 1

puts "Press ENTER to reboot following nodes"
puts client_list.join( " " )
STDIN.gets

system( "/etc/init.d/dhcp stop" )

$node_list.each{ |host|
  TCPSocket.open( host, $PORT ) { |f|
  }
}