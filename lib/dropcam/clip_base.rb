require_relative 'base'
require_relative 'clip_archive'
module Dropcam
  class ClipBase < Base
    def initialize(camera)
      @camera = camera
    end
    
    def all
      response = get(::CLIP_GET_ALL,{},@camera.cookies)
      clips = []
      all_clips = JSON.parse(response.body)["items"]
      for clip in all_clips
        c = Clip.new(@camera, clip)
        if c.camera_id == @camera.id
          clips.push c
        end
      end
      clips
    end
    
    def archive
      ClipArchive.new(@camera)
    end
    
    def create(length, start_date, title, description)
      params = {"uuid"=>@camera.uuid, "length" => length, "start_date" => start_date, "title" => title, "description" => description}
      response = post(::VIDEOS_REQUEST, params, @camera.cookies)      
      clip_info = JSON.parse(response.body)["items"][0]
      return Clip.new(@camera, clip_info)
      
    end
    
  end
end