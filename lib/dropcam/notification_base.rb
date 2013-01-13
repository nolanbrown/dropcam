require_relative 'base'
module Dropcam
  class NotificationBase < Base
    
    attr_accessor :name, :type, :value, :is_enabled, :id
    
    def initialize(camera)
      @camera = camera
    end
    
    def devices
      
      response = get(::CAMERA_FIND_NOTIFICATIONS, { "id" => @camera.uuid }, @camera.cookies)      
      notifications = []

      all_notifications = JSON.parse(response.body)["items"]
      all_notifications.each{|note|
        notifications.push Notification.new(@camera, note["target"])
      }
      
      notifications
    end
    
    def delete(notifcation_id)
      response = post(::CAMERA_DELETE_NOTIFICATION, {"id"=>notifcation_id}, @camera.cookies)      
      true
    end
    
    ## API for Notifications doesn't include email notifcations
    ## The code below parses an HTML Partial to get all notifcation values
    
    # def all_notification_devices
    #   request_path = ::CAMERA_HTML_SETTINGS_BASE + @uuid
    #   response = get(request_path, {}, @cookies)      
    #   if response.success?
    #     raw_html = response.body
    #     doc = Hpricot.parse(raw_html)
    # 
    #     notifications = []
    #     doc.search("//div[@class='notification_target']").each { |notification_target|
    #       puts notification_target
    #       data_id =  notification_target.get_attribute("data-id")
    #       puts data_id
    #       name =  notification_target.at("div/span").inner_text
    #       
    #       input =  notification_target.at("div/input")
    # 
    #       attributes = input.attributes.to_hash
    #       data_type = attributes["data-type"]
    #       data_value = attributes["data-value"]
    #       checked = attributes.has_key?("checked")
    #       
    # 
    #       notifications.push(note)
    #     }
    #     return notifications
    #   elsif response.not_authorized?
    #     raise AuthorizationError 
    #   else 
    #     raise CameraNotFoundError 
    #   end
    # end


  end
end