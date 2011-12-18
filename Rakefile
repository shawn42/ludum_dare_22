libdir = File.dirname(__FILE__)+"/lib"
$: << libdir
confdir = File.dirname(__FILE__)+"/config"
$: << confdir

require 'environment'
$: << GAMEBOX_PATH
load "tasks/gamebox_tasks.rake"
load "tasks/release_packager.rake"
STATS_DIRECTORIES = [
  %w(Source            src/), 
  %w(Config            config/), 
  %w(Maps              maps/), 
  %w(Unit\ tests       specs/),
  %w(Libraries         lib/),
].collect { |name, dir| [ name, "#{APP_ROOT}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }



desc "Search and replace text in files"
task :replace do
  old = ENV["old"]
  new = ENV["new"]
  search = ENV["in"] || ENV["search"] || "*.rb"
  raise "Provide args old= and new=" unless old and new 
  sh %{ruby -p -i -e "gsub(/#{old}/, '#{new}')" `find . -name "#{search}"`}
end
