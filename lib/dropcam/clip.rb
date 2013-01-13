require_relative 'clip_base'

module Dropcam
  class Clip < ClipBase    
    attr_reader :id, :public_link, :description, :title, :is_error, :start_time, :server, :camera_id, :generated_time
    attr_reader :filename, :length_in_seconds
    
    attr_accessor :properties
    def initialize(camera, properties = nil)
      super(camera)
      self.properties = properties
    end
    
    def properties=(properties)
      properties.each{|key, value|
        instance_variable_set("@#{key}", value)
      }
      @properties = properties
    end
        
    # def title=(title)
    #   return false unless @id
    #   response = post(::CLIP_DELETE, { "id" => @id, "title" => title }, @camera.cookies)      
    #   true
    # end
    
    def destroy
      return false unless @id
      response = post(::CLIP_DELETE, { "id" => @id }, @camera.cookies)      
      true
    end
    
    def direct_link
      return "https://#{@server}/#{@filename}"
    end
    def direct_screenshot_link
      return "https://#{@server}/s3#{File.basename(@filename, File.extname(@filename))}.jpg"
    end
  end
end