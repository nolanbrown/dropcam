require 'uri'
require 'net/http'
require 'json'

module Net
  class HTTPResponse
    def success?
      self.code.to_i == 200
    end
    def not_found?
      self.code.to_i == 404
    end
    def error?
      self.code.to_i == 400
    end
    def not_authorized?
      self.code.to_i == 403
    end
  end
end

module Dropcam
  class Base
    attr_accessor :session_token, :cookies
    
    
    ::NEXUS_API_BASE = "https://nexusapi.dropcam.com/"
    
    ::NEXUS_GET_IMAGE_PATH = "get_image" # uuid and width
    ::NEXUS_GET_AVAILABLE_PATH = "get_available" # start_time and uuid
    ::NEXUS_GET_CUEPOINT_PATH = "get_cuepoint" # start_time_uuid
    ::NEXUS_GET_EVENT_CLIP_PATH = "get_event_clip" # start_time_uuid
    ::NEXUS_GET_REVERSE_PAGINATED_CUEPOINTS_PATH = "get_reverse_paginated_cuepoint"
    ::API_BASE = "https://www.dropcam.com"
    ::API_PATH = "/api/v1"
    
    
    ::CAMERA_HTML_SETTINGS_BASE = "/cameras/settings/" # /uuid
    
    ::USERS_LOGIN = "#{API_PATH}/login.login"
    ::CAMERAS_UPDATE = "#{API_PATH}/cameras.update" # uuid, is_public
    ::CAMERAS_GET_BY_PUBLIC_TOKEN = "#{API_PATH}/cameras.get_by_public_token"
    ::CAMERAS_GET = "#{API_PATH}/cameras.get" # uuid
    ::CAMERAS_GET_VISIBLE = "#{API_PATH}/cameras.get_visible"
    ::CAMERAS_GET_PUBLIC = "#{API_PATH}/cameras.get_demo"
    
    ::DROPCAMS_GET_PROPERTIES = "#{API_PATH}/dropcams.get_properties" # uuid
    ::DROPCAMS_SET_PROPERTY = "#{API_PATH}/dropcams.set_property" # POST: uuid, key, value
    ::CAMERA_NOTIFICATION_UPDATE = "#{API_PATH}/camera_notifications.update"
    ::CAMERA_ADD_EMAIL_NOTIFICATION = "#{API_PATH}/users.add_email_notification_target"
    ::CAMERA_DELETE_NOTIFICATION = "#{API_PATH}/users.delete_notification_target"
    ::CAMERA_FIND_NOTIFICATIONS = "#{API_PATH}/camera_notifications.find_by_camera"
    
    ::SUBSCRIPTIONS_LIST = "#{API_PATH}/subscriptions.list" # camera_uuid
    ::SUBSCRIPTIONS_DELETE = "#{API_PATH}/subscriptions.delete"
    ::SUBSCRIPTIONS_CREATE_PUBLIC = "#{API_PATH}/subscriptions.create_public"
    ::USERS_GET_SESSION_TOKEN = "#{API_PATH}/users.get_session_token"
    ::USERS_GET_CURRENT = "#{API_PATH}/users.get_current"
    
    ::CLIP_GET_ALL = "#{API_PATH}/videos.get_owned"
    ::CLIP_CREATE = "#{API_PATH}/videos.request" # POST:  start_date (ex. 1357598395), title, length (in seconds), uuid, description
    ::CLIP_DELETE = "#{API_PATH}/videos.delete" # DELETE:  id = clip_id
    
    ## videos.get # id = clip_id
    ## videos.download # id = clip_id
    ## videos.play # id = clip_idß
    def post(path, parameters, cookies, use_nexus=false)

      http = _dropcam_http(use_nexus)
      
      request = Net::HTTP::Post.new(path)
      request.set_form_data(parameters)
      
      request.add_field("Cookie",cookies.join('; ')) if cookies

      response = http.request(request)
      
      return response
    end
    
    def get(path, parameters,cookies, use_nexus=false)
      http = _dropcam_http(use_nexus)
            
      query_path = "#{path}"
      query_path = "#{path}?#{URI.encode_www_form(parameters)}" if parameters.length > 0
      request = Net::HTTP::Get.new(query_path)      
      
      request.add_field("Cookie",cookies.join('; ')) if cookies
            
      response = http.request(request)
      return response
    end
    
    def delete(path, parameters,cookies, use_nexus=false)
      http = _dropcam_http(use_nexus)
            
      query_path = "#{path}"
      query_path = "#{path}?#{URI.encode_www_form(parameters)}" if parameters.length > 0
      request = Net::HTTP::Delete.new(query_path)      
      
      request.add_field("Cookie",cookies.join('; ')) if cookies
            
      response = http.request(request)
      return response
    end
    
    protected
    
    def _dropcam_http(use_nexus)
      base = API_BASE
      base = NEXUS_API_BASE if use_nexus
      uri = URI.parse(base)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      #http.set_debug_output($stdout)
      
      return http
    end
    
    
  end
  
  
  
end