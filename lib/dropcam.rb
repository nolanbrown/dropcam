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
      camera = JSON.parse(response.body)["items"][0]
      Camera.new(camera["uuid"], camera)
    end
    
    def public_cameras      
      response = get(::CAMERAS_GET_PUBLIC, {}, @session.cookies)
      public_cameras = JSON.parse(response.body)["items"]
      json_to_camera(public_cameras)
    end
    
    def cameras      
      response = get(::CAMERAS_GET_VISIBLE, {"group_cameras" => true}, @session.cookies)
      response_json = JSON.parse(response.body)
      owned = response_json["items"][0]["owned"]
      json_to_camera(owned, true)
    end
    
    private
    def json_to_camera(json, set_session=true)
      cameras = []
      
      json.each{|camera|
        c = Camera.new(camera["uuid"], camera)
        c.cookies = @session.cookies if set_session
        c.session_token = @session.session_token if set_session
        cameras.push(c)
      }
      cameras
    end
    
  end
end
