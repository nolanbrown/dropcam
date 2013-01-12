module Dropcam
  class Setting < Base
    # 
    attr_accessor :name
    def initialize(name, value, camera)
      @camera = camera
      @name = name
      @current_value = value
    end
    
    def value
      return false if @current_value == 'false'
      return true if @current_value == 'true'
      
      @current_value
    end
    
    def to_s
      "<Dropcam::Setting:#{object_id} @name=#{@name} @value=#{@current_value}>"
    end
    
    def set(value)
      response = post(::DROPCAMS_SET_PROPERTY, {"uuid"=>@camera.uuid, "key" => @name, "value" => value}, @camera.cookies)     
      if response.success?
        @current_value = value
        @camera.settings = JSON.parse(response.body)["items"][0]
        true
      elsif response.error?
        raise UnkownError, JSON.parse(response.body)["status_detail"]
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
  end
end