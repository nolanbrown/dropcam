lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'dropcam'
require 'awesome_print'
dropcam = Dropcam::Dropcam.new(ENV["DROPCAM_USERNAME"],ENV["DROPCAM_PASSWORD"])
camera = dropcam.cameras.first
camera.notification_devices.each{|notification|
  # print all variable values
  notification.instance_variables.each{|variable|
    print "#{variable} : "; $stdout.flush
    ap notification.instance_variable_get(variable)
  }
  
  # enable or disable notification
  # notification.set_enabled(true)
  puts "\n------------------------------------\n\n"
  
}
