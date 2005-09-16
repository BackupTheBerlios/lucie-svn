require 'rbconfig'
require 'find'
require 'ftools'

include Config

$ruby = CONFIG['ruby_install_name']

##
# Install a binary file. We patch in on the way through to
# insert a #! line. If this is a Unix install, we name
# the command (for example) 'rake' and let the shebang line
# handle running it. Under windows, we add a '.rb' extension
# and let file associations to their stuff
#

def installBIN(from, opfile)

  tmp_dir = nil
  for t in [".", "/tmp", "c:/temp", $bindir]
    stat = File.stat(t) rescue next
    if stat.directory? and stat.writable?
      tmp_dir = t
      break
    end
  end

  fail "Cannot find a temporary directory" unless tmp_dir
  tmp_file = File.join(tmp_dir, "_tmp")
    
  File.open(from) do |ip|
    File.open(tmp_file, "w") do |op|
      ruby = File.join($realbindir, $ruby)
#      op.puts "#!#{ruby} -w"
      op.puts "#!#{ruby}"
      op.write ip.read
    end
  end

  opfile += ".rb" if CONFIG["target_os"] =~ /mswin/i
  File::install(tmp_file, File.join($bindir, opfile), 0755, true)
  File::unlink(tmp_file)
end

$sitedir = CONFIG["sitelibdir"]
version = CONFIG["MAJOR"]+"."+CONFIG["MINOR"]
$libdir = File.join(CONFIG["libdir"], "ruby", version)

unless $sitedir
  version = CONFIG["MAJOR"]+"."+CONFIG["MINOR"]
  $libdir = File.join(CONFIG["libdir"], "ruby", version)
  $sitedir = $:.find {|x| x =~ /site_ruby/}
  if !$sitedir
    $sitedir = File.join($libdir, "site_ruby")
  elsif $sitedir !~ Regexp.quote(version)
    $sitedir = File.join($sitedir, version)
  end
end

$bindir =  CONFIG["bindir"]
$sbindir = CONFIG["sbindir"]

$realbindir = $bindir

bindir = CONFIG["bindir"]
if (destdir = ENV['DESTDIR'])
  $bindir  = destdir + $bindir
  $sbindir = destdir + $sbindir
  $sitedir = destdir + $sitedir
  $libdir  = destdir + $libdir
  
  File::makedirs($bindir)
  File::makedirs($sbindir)
  File::makedirs($sitedir)
end

# rake_dest = File.join($sitedir, "rake")
# File::makedirs(rake_dest, true)
# File::chmod(0755, rake_dest)

# The library files

files = Dir.chdir('lib') { Dir['**/*.rb'] }

for fn in files
  fn_dir = File.dirname(fn)
#  target_dir = File.join($sitedir, fn_dir)
  target_dir = File.join($libdir, fn_dir)
  if ! File.exist?(target_dir)
    File.makedirs(target_dir)
  end
#  File::install(File.join('lib', fn), File.join($sitedir, fn), 0644, true)
  File::install(File.join('lib', fn), File.join($libdir, fn), 0644, true)
end

# and the executable

installBIN("bin/lucie-setup.rb", "lucie-setup")
installBIN("bin/deft.rb", "deft")

system("install -m0755 bin/start-stop-daemon #{$sbindir}")
system("install -m0755 bin/dhclient-script #{$sbindir}")
system("install -m0755 bin/dhclient-perl #{$sbindir}")

# /usr/sbin 用ファイル
system("install -m0755 bin/ftar             #{$sbindir}")
system("install -m0755 bin/fcopy            #{$sbindir}")
system("install -m0755 bin/install_packages #{$sbindir}")
system("install -m0755 bin/setup_harddisks  #{$sbindir}")
system("install -m0755 bin/hwdetect         #{$sbindir}")
system("install -m0755 bin/mount2dir        #{$sbindir}")
system("install -m0755 bin/fai-do-scripts   #{$sbindir}")

# /sbin 用ファイル
system("install -m0755 bin/rcS_lucie #{$sbindir}")
