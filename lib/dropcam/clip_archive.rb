require_relative 'base'

module Dropcam
  class ClipArchive < Base
    
    def initialize(camera)
      @camera = camera
    end
    
    def image_archive(cuepoint_id, number_of_frames, width)      
      params = {"uuid"=>@camera.uuid, "width" => width, "cuepoint_id" => cuepoint_id, "num_frames" => number_of_frames, "format" => "TAR_JPG"}
      response = get(::NEXUS_GET_EVENT_CLIP_PATH, params, @camera.cookies, true)      
      response
    end
    
    def get_mp4(cuepoint_id, number_of_frames, width)      
      params = {"uuid"=>@camera.uuid, "width" => width, "cuepoint_id" => cuepoint_id, "num_frames" => number_of_frames, "format" => "h264"}
      response = get(::NEXUS_GET_EVENT_CLIP_PATH, params, @camera.cookies, true)      
      response
    end
  end
end