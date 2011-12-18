APP_ROOT = "#{File.join(File.dirname(__FILE__),"..")}/"

CONFIG_PATH = APP_ROOT + "config/"
DATA_PATH =  APP_ROOT + "data/"
SOUND_PATH =  APP_ROOT + "data/sounds/"
MUSIC_PATH =  APP_ROOT + "data/music/"
GFX_PATH =  APP_ROOT + "data/graphics/"
FONTS_PATH =  APP_ROOT + "data/fonts/"

begin
  require 'bundler'
  Bundler.setup
rescue LoadError
  # Gross, for packaging
end

require 'gamebox'
require 'tween'

[GAMEBOX_PATH, APP_ROOT, File.join(APP_ROOT,'src')].each{|path| $: << path }
require "gamebox_application"

require_all Dir.glob("#{APP_ROOT}/**/*.rb").reject{ |f| f.match("spec") || f.match("src/app.rb")}

GAMEBOX_DATA_PATH =  GAMEBOX_PATH + "data/"
GAMEBOX_SOUND_PATH =  GAMEBOX_PATH + "data/sounds/"
GAMEBOX_MUSIC_PATH =  GAMEBOX_PATH + "data/music/"
GAMEBOX_GFX_PATH =  GAMEBOX_PATH + "data/graphics/"
GAMEBOX_FONTS_PATH =  GAMEBOX_PATH + "data/fonts/"

# NEEDED FOR PACKAGING
GAME_NAME = "AppetiteForDestruction"
RELEASE_VERSION = '0.1'

APP = GAME_NAME
GAME_URL = "com.github.shawn42.#{APP}"



