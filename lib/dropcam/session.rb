require_relative 'base'
module Dropcam
  class Session < Base
    
    attr_accessor :session_token, :cookies
    def initialize(username, password)
      @username = username
      @password = password
    end
    
    def authenticate
      
      params = {"username" => @username, "password" => @password}
      response = post(::USERS_LOGIN, params, nil)
      all_cookies = response.get_fields('set-cookie') # only cookies are set on valid credentials
      
      ## for some reason, dropcam responds with 200 on invalid credentials
      if response.success? and all_cookies
        
        cookies = []
        all_cookies.each { | cookie |
            cookies.push(cookie.split('; ')[0])
        }
        
        @cookies = cookies
        @session_token = _session_token # this value is embedded in the cookie but leaving this as is incase the API changes
        
      else
        raise AuthenticationError, "Invalid Credentials"
      end      
    end
        
        
    
    protected
    def _session_token
      response = get(::USERS_GET_SESSION_TOKEN, {}, @cookies)
      if response.success?
        response_json = JSON.parse(response.body)
        token = response_json["items"][0]
        return token
      end
      return nil
    end

  end
end