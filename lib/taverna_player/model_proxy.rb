
module TavernaPlayer
  class ModelProxy
    attr_reader :class_name

    def initialize(class_name, method_names)
      if class_name.is_a?(String)
        begin
          @class_name = Object.const_get(class_name)
        rescue NameError
          @class_name = class_name.constantize
        end
      end

      method_names.each do |name|
        add_method(name.to_sym)
      end
    end

    private

    def add_method(name)
      setter = "#{name}_method_name=".to_sym
      mapper = name

      (class << self; self; end).instance_eval do
        # Define the method to use the mapped method on the object.
        define_method name do |object|
          result = mapper.nil? ? "" : object.send(mapper)
          result.empty? ? "" : result
        end

        # Define the method used to set the mapped method's name.
        define_method setter do |method_name|
          mapper = method_name.nil? ? nil : method_name.to_sym
        end
      end
    end

  end
end
