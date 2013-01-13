require_relative 'notification_base'

module Dropcam
  class Notification < NotificationBase
    
    attr_accessor :name, :type, :value, :is_enabled, :id
    
    def initialize(camera, properties={})
      super(camera)
      @name = properties["name"]
      @type = properties["type"]
      @value = properties["value"]
      @id = properties["id"]
      @is_enabled = properties["enabled"]
    end
    
    def find(name)
      note = @camera.notification_devices.select{|note|
        if note.name == name
          return note
        end
      }
      note
    end
    
    def create(email)
      # {"status": 400, "items": [], "status_description": "bad-request", "status_detail": "This notification target already exists"}
      response = post(::CAMERA_ADD_EMAIL_NOTIFICATION, {"email"=>email}, @camera.cookies)     
      return Notification.new(@camera, JSON.parse(response.body)["items"][0])

    end
    
    def set(enable)
      # email or gcm or apn
      params = {"id"=>@camera.uuid, "is_enabled"=>enable, "device_token" => @value}
      response = post(::CAMERA_NOTIFICATION_UPDATE, params, @camera.cookies)      
      true
    end
    
    def delete
      super(@id)
    end

  end
end