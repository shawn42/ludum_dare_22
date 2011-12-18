# raise "OSX_GEMS must be defined for release" unless defined? OSX_GEMS
OSX_GEMS = (Bundler.setup(:package).gems.map(&:name) - %w(bundler gosu)).sort

# GAME_URL = "com.github.shawn42.#{APP}"
OSX_APP = "#{APP.split("_").map(&:capitalize).join(" ")}.app"

RELEASE_FOLDER_OSX = "#{RELEASE_FOLDER_BASE}_OSX"

# http://www.libgosu.org/downloads/
OSX_BUILD_DIR =  File.expand_path("~/gosu_wrappers")
BASE_OSX_APP = File.join(OSX_BUILD_DIR, "RubyGosu App.app")
TMP_OSX_PKG_DIR = File.join(OSX_BUILD_DIR, File.basename(RELEASE_FOLDER_OSX))
TMP_OSX_APP = File.join(TMP_OSX_PKG_DIR, OSX_APP)
TMP_OSX_SOURCE_DIR = File.join(TMP_OSX_APP, "Contents", "Resources", APP) # Where I copy my game source.
TMP_OSX_GEM_DIR = File.join(TMP_OSX_APP, "Contents", "Resources", 'lib') # Gem location.
TMP_OSX_INFO_FILE = File.join(TMP_OSX_APP, "Contents", "Info.plist")
TMP_OSX_MAIN_FILE = File.join(TMP_OSX_APP, "Contents", "Resources", "Main.rb")
TMP_OSX_RUBY = File.join(TMP_OSX_APP, "Contents", "MacOS", "RubyGosu App")

RUN_FILE_OLD = File.join(TMP_OSX_SOURCE_DIR, "src/app.rb")
RUN_FILE_NEW = RUN_FILE_OLD#.sub('.rbw', '.rb')

desc "Create OS X releases v#{RELEASE_VERSION}"
task "release:osx" => ["build:osx:app"]

# Create folders for release.
file RELEASE_FOLDER_OSX => [OSX_APP, README_HTML] do
  mkdir_p RELEASE_FOLDER_OSX
  cp OSX_APP, RELEASE_FOLDER_OSX
  cp CHANGELOG_FILE, RELEASE_FOLDER_OSX
  cp README_HTML, RELEASE_FOLDER_OSX
end

file OSX_APP => "build:osx:app"

desc "Generate #{OSX_APP} (OS X) v#{RELEASE_VERSION}"
task "build:osx:app" => :readme do
  puts "--- Copying App #{TMP_OSX_PKG_DIR}" 
  mkdir_p TMP_OSX_PKG_DIR

  raise "ERROR: Could not find #{BASE_OSX_APP}" unless File.exists? BASE_OSX_APP

  cp_r BASE_OSX_APP, TMP_OSX_APP

  # Copy my source files.
  puts "--- Copying source"
  mkdir_p TMP_OSX_SOURCE_DIR
  SOURCE_FOLDERS.each {|f| cp_r f, TMP_OSX_SOURCE_DIR }
  cp README_HTML, TMP_OSX_PKG_DIR
  cp CHANGELOG_FILE, TMP_OSX_PKG_DIR


  # Copy my gems.
  puts "--- Copying gems"
  puts OSX_GEMS.sort.inspect
  rm File.join(TMP_OSX_GEM_DIR, 'chingu.rb')
  rm_rf File.join(TMP_OSX_GEM_DIR, 'chingu')
  OSX_GEMS.each do |gem|
    gem_path = File.join(%x[bundle show #{gem}].chomp, 'lib', '.')
    cp_r gem_path, TMP_OSX_GEM_DIR

    # Some gems use files outside of /lib, which is not supported by the .app!
    extra_folders = case gem
                      when 'nokogiri'
                        %w[ext]
                      when 'fidgit'
                        %w[config media]
                      when 'r18n-core'
                        %w[base locales]
                      when 'clipboard'
                        %w[VERSION]
                      else
                        []
                    end

    extra_folders.each do |folder|
      cp_r File.expand_path(File.join(gem_path, '..', folder)), File.dirname(TMP_OSX_GEM_DIR)
    end
  end

  # Something for the .app to run -> just a little redirection file.
  puts "--- Creating Main.rb"
  # mv RUN_FILE_OLD, RUN_FILE_NEW
  File.open(TMP_OSX_MAIN_FILE, "w") do |file|
    file.puts <<END_TEXT
OSX_EXECUTABLE_FOLDER = File.dirname(File.dirname(File.dirname(__FILE__)))
require_relative File.join('#{APP}', 'src', 'app.rb')
END_TEXT
  end

  # Edit the info file to be specific for my game.
  puts "--- Editing init"
  info = File.read(TMP_OSX_INFO_FILE)
  info.sub!('org.libgosu.UntitledGame', GAME_URL)
  File.open(TMP_OSX_INFO_FILE, "w") {|f| f.puts info }

  # Ensure execute access to the startup file.
  puts "--- Setting execution privilege  App"
  chmod 0755, TMP_OSX_RUBY

  puts "--- Compressing"
  old_dir = pwd
  cd OSX_BUILD_DIR
  package_dir = TMP_OSX_PKG_DIR.sub(OSX_BUILD_DIR, '').sub(/^\//, '')

  #tar_package = "#{package_dir}.tar.bz2"
  #system "tar -jcvf #{tar_package} #{package_dir}"

  #seven_z_package = "#{package_dir}.7z"
  #system "7z a #{seven_z_package} #{package_dir}"

  zip_package = "#{package_dir}.zip"
  system "7z a -tzip #{zip_package} #{package_dir}"

  cd old_dir

  mkdir_p RELEASE_FOLDER

  #mv File.join(OSX_BUILD_DIR, tar_package), RELEASE_FOLDER
  #mv File.join(OSX_BUILD_DIR, seven_z_package), RELEASE_FOLDER
  mv File.join(OSX_BUILD_DIR, zip_package), RELEASE_FOLDER
end
