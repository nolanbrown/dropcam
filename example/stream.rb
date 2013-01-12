lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dropcam'

dropcam = Dropcam::Dropcam.new(ENV["DROPCAM_USERNAME"],ENV["DROPCAM_PASSWORD"])
camera = dropcam.cameras.first

puts "\nRTSP URI"
puts camera.stream.rtsp_uri.to_s

puts "\nRTMPDump command"
puts camera.stream.rtmpdump

puts "\nSave Live Stream as FLV"
puts camera.stream.save_live("#{camera.title}.flv",30)