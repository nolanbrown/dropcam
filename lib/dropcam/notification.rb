module Dropcam
  class Notification < Base
    
    attr_accessor :name, :type, :value, :is_enabled, :id
    
    def initialize(camera, properties={})
      @camera = camera
      @name = properties["name"]
      @type = properties["type"]
      @value = properties["value"]
      @id = properties["id"]
      @is_enabled = properties["enabled"]
    end
    
    def find(name)
      note = @camera.notification_devices.select{|note|
        if note.name == name
          puts "#{note.name} == #{name}"
          return note
        end
      }
      note
    end
    
    def create(email)
      # {"status": 400, "items": [], "status_description": "bad-request", "status_detail": "This notification target already exists"}
      response = post(::CAMERA_ADD_EMAIL_NOTIFICATION, {"email"=>email}, @camera.cookies)     
      if response.success?
        return Notification.new(@camera, JSON.parse(response.body)["items"][0])
      elsif response.error?
        raise UnkownError, JSON.parse(response.body)["status_detail"]
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def set(enable)
      # email or gcm or apn
      params = {"id"=>@camera.uuid, "is_enabled"=>enable, "device_token" => @value}
      puts params
      response = post(::CAMERA_NOTIFICATION_UPDATE, params, @camera.cookies)      
      if response.success?
        return true
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def delete(notifcation_id=nil)
      notifcation_id = @id unless notifcation_id
      response = post(::CAMERA_DELETE_NOTIFICATION, {"id"=>notifcation_id}, @camera.cookies)      
      if response.success?
        return true
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end

  end
end