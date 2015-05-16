require_relative 'base'
require_relative 'error'
require_relative 'notification'
require_relative 'notification_base'
require_relative 'cuepoint_base'
require_relative 'clip'
require_relative 'clip_base'
require_relative 'setting'
require_relative 'stream'
require_relative 'screenshot'

module Dropcam
  class Camera < Base
    
    attr_reader :uuid, :notification_devices, :download_host, :download_server_live, :is_streaming, :name, :public_token
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
    
    def settings=(new_settings)
      @settings = {}
      return @settings unless new_settings
      new_settings.each{|key,value|
        @settings[key] = Setting.new(key, value, self)
      }
      @settings
    end
    
    def settings(force=false)
      return @settings unless force == true or @settings.length == 0 # key these cached
      
      response = get(::DROPCAMS_GET_PROPERTIES, {"uuid"=>@uuid}, @cookies)      
      self.settings = JSON.parse(response.body)["items"][0]
      @settings
    end
    
    
    def screenshot
      @screenshot = Screenshot.new(self) unless @screenshot
      @screenshot
    end
    
    def clip
      @clip_base = ClipBase.new(self) unless @clip_base
      @clip_base
    end
    def cuepoint
      @cuepoint_base = CuepointBase.new(self) unless @cuepoint_base
      @cuepoint_base
    end

    def stream
      @stream = Stream.new(self) unless @stream
      @stream
    end
    
    def notification
      @notification = NotifcationBase.new(self) unless @notification
      @notification
    end
    
    
    def update_info
      response = get(::CAMERAS_GET, {"id"=>@uuid}, @cookies)      
      self.properties = JSON.parse(response.body)["items"][0]

    end
    
    
    
    def public=(is_public)
      response = post(::CAMERAS_UPDATE, {"uuid"=>@uuid, "is_public"=>is_public, "accepted_public_terms_at" => "true"}, @cookies)      
      self.properties = JSON.parse(response.body)["items"][0]
    end
    
    def public?
      @is_public
    end
    
    def set_public_token(token)
      response = post(::CAMERAS_UPDATE, {"uuid"=>@uuid, "token"=>token}, @cookies)      
      self.properties = JSON.parse(response.body)["items"][0]
      true
    end
  

      
  end
end
