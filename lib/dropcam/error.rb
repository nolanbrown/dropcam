module Dropcam
  class AuthenticationError < StandardError
    def initialize(msg = "Invalid Credentials")
      super(msg)
    end
  end
  class AuthorizationError < StandardError
    def initialize(msg = "Not Authorized")
      super(msg)
    end
  end
  class CameraNotFoundError < StandardError
    def initialize(msg = "Camera Not Found")
      super(msg)
    end
  end
  class UnkownError < StandardError
    def initialize(msg = "Unkown Error")
      super(msg)
    end
  end
  class RequestError < StandardError
    def initialize(msg = "Request Error")
      super(msg)
    end
  end

end