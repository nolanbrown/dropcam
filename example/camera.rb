lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dropcam'
require 'awesome_print'

dropcam = Dropcam::Dropcam.new(ENV["DROPCAM_USERNAME"],ENV["DROPCAM_PASSWORD"])

all_cameras = dropcam.cameras
all_cameras.each { |aCamera|
  puts "\n------------------------------------\n"
  aCamera.instance_variables.each{|variable|
    print "#{variable} : "; $stdout.flush
    ap aCamera.instance_variable_get(variable)
  }
}