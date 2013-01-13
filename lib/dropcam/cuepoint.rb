require_relative 'cuepoint_base'
require_relative 'clip_archive'

module Dropcam
  class Cuepoint < CuepointBase
    attr_reader :id, :note, :type, :time
    
    def initialize(camera,details)
      super(camera)
      @id = details["id"]
      @note = details["note"]
      @type = details["type"]
      @time = details["time"]
    end
    
    def mp4(number_of_frames, width) 
      ClipArchive.new(@camera).get_mp4(self.id, number_of_frames, width)
    end
    
    def image_archive(number_of_frames, width) 
      ClipArchive.new(@camera).image_archive(self.id, number_of_frames, width)
    end
  end
end