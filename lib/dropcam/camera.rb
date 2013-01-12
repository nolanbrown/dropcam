require 'hpricot'

require_relative 'base'
require_relative 'error'
require_relative 'notification'
require_relative 'setting'
require_relative 'cuepoint'
require_relative 'clip'
require_relative 'stream'

module Dropcam
  class Camera < Base
    
    attr_reader :uuid, :notification_devices, :download_host, :download_server_live, :is_streaming, :title, :public_token
    attr_reader :description, :timezone_utc_offset, :timezone, :is_connected, :is_online, :is_public, :hours_of_recording_max
    attr_reader :type, :id, :owner_id
    attr_accessor :settings

    
    def initialize(uuid, properties={})
      @uuid = uuid
      @settings = {}
      self.properties = properties
    end
    
    def properties=(properties)
      properties.each{|key, value|
        instance_variable_set("@#{key}", value)
      }
    end
    
    
    def get_image(width=1200, timestamp=nil)
      params = {"uuid"=>@uuid, "width" => width}
      params["time"] = timestamp if timestamp
      
      response = get(::IMAGE_PATH, params, @cookies, true)      
      if response.success?
        return response.body
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def current_image(width=1200)
      return get_image(width)
    end
    
    def clips
      response = get(::CLIP_GET_ALL, {}, @cookies)      
      if response.success?
        return response.body ## returns a zip
        clips = []
        all_clips = JSON.parse(response.body)["items"]
        for clip in all_clips
          c = Clip.new(self, clip)
          if c.camera_id == self.id
            clips.push c
          end
        end
        return clips
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    
    def create_clip(length, start_date, title, description)
      params = {"uuid"=>@uuid, "length" => length, "start_date" => start_date, "title" => title, "description" => description}
      response = post(::VIDEOS_REQUEST, params, @cookies)      
      if response.success?
        clip_info = JSON.parse(response.body)["items"][0]
        return Clip.new(self, clip_info)
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    
    def get_event_clip_image_archive(cuepoint_id, number_of_frames, width)      
      params = {"uuid"=>@uuid, "width" => width, "cuepoint_id" => cuepoint_id, "num_frames" => number_of_frames, "format" => "TAR_JPG"}
      response = get(::NEXUS_GET_EVENT_CLIP_PATH, params, @cookies, true)      
      if response.success?
        return response.body ## returns a zip
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def get_event_clip_video(cuepoint_id, number_of_frames, width)      
      params = {"uuid"=>@uuid, "width" => width, "cuepoint_id" => cuepoint_id, "num_frames" => number_of_frames, "format" => "h264"}
      response = get(::NEXUS_GET_EVENT_CLIP_PATH, params, @cookies, true)      
      if response.success?
        return response.body ## returns a zip
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def get_all_cuepoints(limit=2500)
      params = {"uuid"=>@uuid, "max_results"=>limit}
      response = get(::NEXUS_GET_REVERSE_PAGINATED_CUEPOINTS_PATH, params, @cookies, true)      
      if response.success?
        cuepoints = []
        all_cuepoints = JSON.parse(response.body)
        for cuepoint in all_cuepoints
          cuepoints.push Cuepoint.new(cuepoint)
        end
        
        return cuepoints
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
        
    def get_cuepoint(start_time)
      params = {"uuid"=>@uuid, "start_time" => start_time}
      response = get(::NEXUS_GET_CUEPOINT_PATH, params, @cookies, true)      
      if response.success?
        return Cuepoint.new(JSON.parse(response.body)[0])        
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def update_info
      response = get(::CAMERAS_GET, {"id"=>@uuid}, @cookies)      
      if response.success?
        self.properties = JSON.parse(response.body)["items"][0]
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    
    
    def public=(is_public)
      response = post(::CAMERAS_UPDATE, {"uuid"=>@uuid, "is_public"=>is_public, "accepted_public_terms_at" => "true"}, @cookies)      
      if response.success?
        self.properties = JSON.parse(response.body)["items"][0]
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def public?
      @is_public
    end
    
    def set_public_token(token)
      response = post(::CAMERAS_UPDATE, {"uuid"=>@uuid, "token"=>token}, @cookies)      
      if response.success?
        self.properties = JSON.parse(response.body)["items"][0]
        return true
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def settings=(new_settings)
      @settings = {}
      new_settings.each{|key,value|
        @settings[key] = Setting.new(key, value, self)
      }
      @settings
    end
    
    def settings(force=false)
      return @settings unless force == true or @settings.length == 0 # key these cached
      
      response = get(::DROPCAMS_GET_PROPERTIES, {"uuid"=>@uuid}, @cookies)      
      if response.success?
        self.settings = JSON.parse(response.body)["items"][0]
        return @settings
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def notification_devices
      
      response = get(::CAMERA_FIND_NOTIFICATIONS, { "id" => @uuid }, @cookies)      
      if response.success?
        notifications = []

        all_notifications = JSON.parse(response.body)["items"]
        all_notifications.each{|note|
          notifications.push Notification.new(self, note["target"])
        }
        
        notifications
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    ## API for Notifications doesn't include email notifcations
    ## The code below parses an HTML Partial to get all notifcation values
    
    def all_notification_devices
      request_path = ::CAMERA_HTML_SETTINGS_BASE + @uuid
      response = get(request_path, {}, @cookies)      
      if response.success?
        raw_html = response.body
        doc = Hpricot.parse(raw_html)
    
        notifications = []
        doc.search("//div[@class='notification_target']").each { |notification_target|
          puts notification_target
          data_id =  notification_target.get_attribute("data-id")
          puts data_id
          name =  notification_target.at("div/span").inner_text
          
          input =  notification_target.at("div/input")
    
          attributes = input.attributes.to_hash
          data_type = attributes["data-type"]
          data_value = attributes["data-value"]
          checked = attributes.has_key?("checked")
          
    
          notifications.push(note)
        }
        return notifications
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    
    
    def stream
      Stream.new self
    end
      
  end
end