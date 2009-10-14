module RestSinatra

  def self.included(includer)
    includer.extend(ClassMethods)
  end

  module ClassMethods
    
    attr_reader :config
  
    def resource(name, &block)
      _resource(name, :regular, &block)
    end
    
    def nestable_resource(name, &block)
      _resource(name, :nestable, &block)
    end
    
    protected
    
    def _resource(name, resource_type, &block)
      config = evaluate_block(name, resource_type, &block)
      config[:resource] = self
      validate(config)
      build_resource(config)
      config
    end
    
    def evaluate_block(name, resource_type, &block)
      scope = Object.new
      scope.extend(ResourceMethods)
      scope.instance_eval do
        @c = {
          :name             => name,
          :resource_type    => resource_type,
          :model            => nil,
          :read_only        => [],
          :resource         => nil,
          :permission       => nil,
          :callbacks        => {},
          :nested_resources => []
        }
      end
      scope.instance_eval(&block)
      scope.instance_variable_get("@c")
    end
    
    def validate(c)
      raise "name required" unless c[:name]
      raise "model required" unless c[:model]
      c[:nested_resources].each do |resource|
        unless resource[:association]
          raise "association required for #{resource[:class]}"
        end
      end
    end
    
    def build_resource(config)
      case config[:resource_type]
      when :regular
        build_parent_resource(config)
        build_nested_resources(config)
      when :nestable
        save_nestable_config(config)
      else
        raise "Unexpected resource_type"
      end
    end

    def build_parent_resource(config)
      callbacks = config[:callbacks]
      model     = config[:model]
      name      = config[:name]
      read_only = config[:read_only]
      resource  = config[:resource]

      get '/?' do
        require_at_least(:basic)
        validate_before_find_all(params, model)
        @documents = find_with_filters(params, model)
        @documents.render
      end

      get '/:id/?' do |id|
        require_at_least(:basic)
        id = params.delete("id")
        validate_before_find_one(params, model)
        @document = find_document!(model, id)
        @document.render
      end

      post '/?' do
        require_at_least(:curator)
        validate_before_create(params, model, read_only)
        callback(callbacks[:before_save])
        callback(callbacks[:before_create])
        @document = model.new(params)
        invalid_document! unless @document.valid?
        internal_server_error! unless @document.save
        callback(callbacks[:after_create])
        callback(callbacks[:after_save])
        response.status = 201
        response.headers['Location'] = full_uri "/#{name}/#{@document.id}"
        @document.render
      end

      put '/:id/?' do
        require_at_least(:curator)
        id = params.delete("id")
        @document = find_document!(model, id)
        validate_before_update(params, model, read_only)
        callback(callbacks[:before_save])
        callback(callbacks[:before_update])
        @document = model.update(id, params)
        invalid_document! unless @document.valid?
        callback(callbacks[:after_update])
        callback(callbacks[:after_save])
        @document.render
      end

      delete '/:id/?' do
        require_at_least(:curator)
        id = params.delete("id")
        @document = find_document!(model, id)
        callback(callbacks[:before_destroy])
        @document.destroy
        callback(callbacks[:after_destroy])
        { "id" => id }.to_json
      end

      helpers do
        def find_document!(model, id)
          document = model.find_by_id(id)
          not_found! unless document
          document
        end
      end

    end

    def build_nested_resources(parent_config)
      parent_config[:nested_resources].each do |resource|
        nested_res_class = resource[:class]
        assoc            = resource[:association]
        nested_config    = restore_nestable_config(nested_res_class)
        build_nested_resource(nested_res_class, assoc, parent_config, nested_config)
      end
    end

    # klass       : nested resource class
    # association : a method on the parent model that will return child models
    def build_nested_resource(klass, association, parent_config, child_config)
      callbacks       = child_config[:callbacks]
      child_model     = child_config[:model]
      child_name      = child_config[:name]
      child_resource  = child_config[:resource]
      permission      = child_config[:permission]
      read_only       = child_config[:read_only]

      parent_model    = parent_config[:model]
      parent_name     = parent_config[:name]
      parent_resource = parent_config[:resource]

      get "/:parent_id/#{child_name}/?" do
        parent_id = params.delete("parent_id")
        permission_check(:basic, permission, parent_id)
        @parent_document = find_parent!(parent_model, parent_id)
        all_child_documents = @parent_document.send(association)
        validate_before_find_all(params, child_model) # ?
        @child_documents = nested_find_with_filters(all_child_documents, params, parent_model)
        @child_documents.render
      end

      get "/:parent_id/#{child_name}/:child_id/?" do
        parent_id = params.delete("parent_id")
        permission_check(:basic, permission, parent_id)
        child_id = params.delete("child_id")
        validate_before_find_one(params, child_model) # ?
        @parent_document, @child_document = find_documents!(parent_model, parent_id, association, child_id)
        @child_document.render
      end

      post "/:parent_id/#{child_name}/?" do
        parent_id = params.delete("parent_id")
        permission_check(:curator, permission, parent_id)
        @parent_document = find_parent!(parent_model, parent_id)
        validate_before_create(params, child_model, read_only)
        callback(callbacks[:before_save])
        callback(callbacks[:before_create])
        @child_document = child_model.new(params)
        @parent_document.send(association) << @child_document
        internal_server_error! unless @parent_document.save
        callback(callbacks[:after_create])
        callback(callbacks[:after_save])
        response.status = 201
        response.headers['Location'] = full_uri(
          "/#{parent_name}/#{parent_id}/#{child_name}/#{@child_document.id}"
        )
        @child_document.render
      end

      put "/:parent_id/#{child_name}/:child_id/?" do
        parent_id = params.delete("parent_id")
        permission_check(:curator, permission, parent_id)
        child_id = params.delete("child_id")
        @parent_document, @child_document = find_documents!(parent_model, parent_id, association, child_id)
        validate_before_update(params, child_model, read_only)
        callback(callbacks[:before_save])
        callback(callbacks[:before_update])
        @child_document.attributes = params
        child_index = @parent_document.send(association).index(@child_document)
        @parent_document.send(association)[child_index] = @child_document
        internal_server_error! unless @parent_document.save
        callback(callbacks[:after_update])
        callback(callbacks[:after_save])
        @child_document.render
      end

      delete "/:parent_id/#{child_name}/:child_id/?" do
        parent_id = params.delete("parent_id")
        permission_check(:curator, permission, parent_id)
        child_id = params.delete("child_id")
        @parent_document, @child_document = find_documents!(parent_model, parent_id, association, child_id)
        callback(callbacks[:before_destroy])
        @parent_document.send(association).delete(@child_document)
        callback(callbacks[:after_destroy])
        internal_server_error! unless @parent_document.save
        { "id" => child_id }.to_json
      end

      helpers do
        def find_parent!(parent_model, parent_id)
          parent_document = parent_model.find_by_id(parent_id)
          not_found! unless parent_document
          parent_document
        end

        def find_child!(parent_document, association, child_id)
          child_document = parent_document.send(association).detect { |x| x.id == child_id }
          not_found! unless child_document
          child_document
        end

        def find_documents!(parent_model, parent_id, association, child_id)
          parent_document = find_parent!(parent_model, parent_id)
          child_document = find_child!(parent_document, association, child_id)
          [parent_document, child_document]
        end
      end
    end

    def save_nestable_config(config)
      @nestable_resource_config = config
    end
    
    def restore_nestable_config(klass)
      klass.instance_variable_get("@nestable_resource_config")
    end

  end
  
  module ResourceMethods
    
    def model(model)
      raise "model already declared" if @c[:model]
      @c[:model] = model
    end

    def read_only(attribute)
      @c[:read_only] << attribute
    end
    
    def permission(level)
      raise "permission already declared" if @c[:permission]
      @c[:permission] = level
    end
    
    def callback(name, &block)
      @c[:callbacks][name] = block
    end
    
    def nested_resource(klass, options)
      @c[:nested_resources] << options.merge({:class => klass})
    end
    
  end
  
end
