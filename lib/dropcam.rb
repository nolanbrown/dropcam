require "dropcam/version"
require "dropcam/base"
require "dropcam/camera"
require "dropcam/session"

module Dropcam
  class Dropcam < Base
    attr_reader :session
    def initialize(username, password)
      @session = Session.new(username, password)
      @session.authenticate
      ## 
    end
    def camera(uuid)
      c = Camera.new(uuid)
      c.cookies = @session.cookies
      c.session_token = @session.session_token
      c.properties = c.info      
      c
    end
    
    def get_public_camera(token)
      response = get(::CAMERAS_GET_BY_PUBLIC_TOKEN, {"token"=>token, "return_deleted"=>true}, @session.cookies)      
      if response.success?
        return response.body
      elsif response.not_authorized?
        raise AuthorizationError 
      else 
        raise CameraNotFoundError 
      end
    end
    
    def public_cameras      
      response = get(::CAMERAS_GET_PUBLIC, {}, @session.cookies)
      cameras = []
      if response.success?
        response_json = JSON.parse(response.body)
        owned = response_json["items"][0]["owned"]
        owned.each{|camera|
          c = Camera.new(camera["uuid"], camera)
          c.cookies = @session.cookies
          c.session_token = @session.session_token
          cameras.push(c)
        }
      end
      return cameras
    end
    
    def cameras      
      response = get(::CAMERAS_GET_VISIBLE, {"group_cameras" => true}, @session.cookies)
      cameras = []
      if response.success?
        response_json = JSON.parse(response.body)
        owned = response_json["items"][0]["owned"]
        owned.each{|camera|
          c = Camera.new(camera["uuid"], camera)
          c.cookies = @session.cookies
          c.session_token = @session.session_token
          cameras.push(c)
        }
      end
      return cameras
    end
  end
end
