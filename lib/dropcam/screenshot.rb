
module Dropcam
  class Screenshot < Base
    # 
    attr_accessor :camera
    def initialize(name)
      @camera = camera
      @name = name
      @current_value = value
    end
    
    def current(width=1200)
      return image_at_time(nil, width)
    end
    
    def image_at_time(timestamp, width=1200)
      params = {"uuid"=>@camera.uuid, "width" => width}
      params["time"] = timestamp if timestamp
      response = get(::IMAGE_PATH, params, @camera.cookies, true)      
      return response
    end
  end
end

