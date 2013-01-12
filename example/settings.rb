lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dropcam'
require 'awesome_print'
dropcam = Dropcam::Dropcam.new(ENV["DROPCAM_USERNAME"],ENV["DROPCAM_PASSWORD"])
camera = dropcam.cameras.first
settings = camera.settings

ap settings

setting_name = "watermark.enabled"
setting_value = settings[setting_name].value
puts "Changing #{setting_name} from #{setting_value} to #{!setting_value}"
settings[setting_name].set(!setting_value)
puts "Changing #{setting_name} is now #{settings[setting_name].value}"
