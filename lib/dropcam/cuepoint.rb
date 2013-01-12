module Dropcam
  class Cuepoint
    attr_reader :id, :note, :type, :time
    def initialize(details)
      @id = details["id"]
      @note = details["note"]
      @type = details["type"]
      @time = details["time"]
    end
  end
end