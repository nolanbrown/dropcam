require 'Open3'
require 'timeout'
module Dropcam
  class Stream
    DEFAULT_RTSP_PORT = "554"
    BUFFER_SIZE = 1024
    
    attr_reader :camera
    def initialize(camera)
      @camera = camera
    end
    def rtsp_details
      {
        :protocol => "rtsp",
        :user => "user",
        :password => @camera.session_token,
        :base => URI.parse(@camera.download_host).scheme,
        :path => @camera.uuid,
        :port => DEFAULT_RTSP_PORT
      }
    end
    def rtsp_uri
      URI.parse "rtsp://user:#{@camera.session_token}@#{URI.parse(@camera.download_host).scheme}:#{DEFAULT_RTSP_PORT}/#{@camera.uuid}"
    end
    
    def rtmp_details
      {
        :app => "nexus",
        :host => "stream.dropcam.com",
        :playpath => @camera.uuid,
        :variables => { "S:" => @camera.session_token }
      }
    end
    
    def rtmpdump
      stream_command = "rtmpdump --live --app nexus --host stream.dropcam.com --playpath " + @camera.uuid
      stream_command += " --conn S:" + @camera.session_token
      return stream_command
    end
    
    def save_live(filename, duration=30)
      raise StandardError, "RTMPDump is not found in your PATH" unless system("which -s rtmpdump")
      # we add 10 seconds because it take about that amount of time to get the stream up and running with rtmpdump
      run_with_timeout("#{self.rtmpdump} --quiet --flv #{filename}", duration+10, 1)
    end
    
    private
    
    # Runs a specified shell command in a separate thread.
    # If it exceeds the given timeout in seconds, kills it.
    # Returns any output produced by the command (stdout or stderr) as a String.
    # Uses Kernel.select to wait up to the tick length (in seconds) between 
    # checks on the command's status
    #
    # If you've got a cleaner way of doing this, I'd be interested to see it.
    # If you think you can do it with Ruby's Timeout module, think again.
    
    ## VIA https://gist.github.com/1032297
    def run_with_timeout(command, timeout, tick)
      output = ''
      begin
        # Start task in another thread, which spawns a process
        stdin, stderrout, thread = Open3.popen2e(command)
        # Get the pid of the spawned process
        pid = thread[:pid]
        start = Time.now

        while (Time.now - start) < timeout and thread.alive?
          # Wait up to `tick` seconds for output/error data
          Kernel.select([stderrout], nil, nil, tick)
          # Try to read the data
          begin
            #output << stderrout.read_nonblock(BUFFER_SIZE)
          rescue IO::WaitReadable
            # A read would block, so loop around for another select
          rescue EOFError
            # Command has completed, not really an error...
            break
          end
        end
        # Give Ruby time to clean up the other thread
        sleep 1

        if thread.alive?
          # We need to kill the process, because killing the thread leaves
          # the process alive but detached, annoyingly enough.
          Process.kill("TERM", pid)
        end
      ensure
        stdin.close if stdin
        stderrout.close if stderrout
      end
      return output
    end
  end
end