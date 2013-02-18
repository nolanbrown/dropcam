lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dropcam'
require 'awesome_print'
dropcam = Dropcam::Dropcam.new(ENV["DROPCAM_USERNAME"],ENV["DROPCAM_PASSWORD"])
camera = dropcam.cameras.first
screenshot = camera.screenshot.current
File.open("#{camera.title}.jpeg", 'w') {|f| f.write(screenshot) }
