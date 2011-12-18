RELEASE_FOLDER_SOURCE = "#{RELEASE_FOLDER_BASE}_SOURCE"

desc "Create source releases v#{RELEASE_VERSION}"
task "release:source" => ["release:source_zip"]

file RELEASE_FOLDER_SOURCE => README_HTML do
  mkdir_p RELEASE_FOLDER_SOURCE
  SOURCE_FOLDERS.each {|f| cp_r f, RELEASE_FOLDER_SOURCE }
  cp EXTRA_SOURCE_FILES, RELEASE_FOLDER_SOURCE
  cp CHANGELOG_FILE, RELEASE_FOLDER_SOURCE
  cp README_HTML, RELEASE_FOLDER_SOURCE
end