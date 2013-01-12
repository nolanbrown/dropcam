#dropcam = Dropcam::Session.new("username","password")
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dropcam'
require 'awesome_print'
dropcam = Dropcam::Dropcam.new(ENV["DROPCAM_USERNAME"],ENV["DROPCAM_PASSWORD"])
camera = dropcam.cameras.first
ap camera.uuid
ap camera.session_token
ap camera.rtsp_url
ap camera.rtmpdump_stream_command

settings = camera.settings
#ap settings["watermark.enabled"].set(false)