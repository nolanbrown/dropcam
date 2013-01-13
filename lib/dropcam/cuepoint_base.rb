module Dropcam
  class CuepointBase < Base
    def initialize(camera)
      @camera = camera
    end
    
    def all(limit=2500)
      params = {"uuid"=>@camera.uuid, "max_results"=>limit}
      response = get(::NEXUS_GET_REVERSE_PAGINATED_CUEPOINTS_PATH, params, @camera.cookies, true)      
      cuepoints = []
      all_cuepoints = JSON.parse(response.body)
      for cuepoint in all_cuepoints
        cuepoints.push Cuepoint.new(cuepoint)
      end
      cuepoints
    end
        
    def cuepoint(start_time)
      params = {"uuid"=>@camera.uuid, "start_time" => start_time}
      response = get(::NEXUS_GET_CUEPOINT_PATH, params, @camera.cookies, true)      
      Cuepoint.new(JSON.parse(response.body)[0])        
    end
    
  end
end

  