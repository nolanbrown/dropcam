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
      if all_cookies
        
        cookies = []
        all_cookies.each { | cookie |
            cookies.push(cookie.split('; ')[0])
        }
        
        @cookies = cookies
        @session_token = JSON.parse(response.body)["items"][0]["session_token"]
        
      else
        raise AuthenticationError, "Invalid Credentials"
      end      
    end

  end
end
