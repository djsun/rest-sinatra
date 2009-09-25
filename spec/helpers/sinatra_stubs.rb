module SinatraStubs
  
  def self.included(includer)
    includer.class_eval do
      @actions = {
        :get     => [],
        :post    => [],
        :put     => [],
        :delete  => []
      }
    end
    includer.extend(ClassMethods)
  end
  
  module ClassMethods
    attr_reader :actions
    
    def get(route)
      @actions[:get] << route
    end

    def post(route)
      @actions[:post] << route
    end

    def put(route)
      @actions[:put] << route
    end

    def delete(route)
      @actions[:delete] << route
    end
    
    def helpers()
      # ...
    end
  end

end
