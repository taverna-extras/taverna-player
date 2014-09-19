#------------------------------------------------------------------------------
# Copyright (c) 2013, 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

module TavernaPlayer
  class ModelProxy
    attr_reader :class_name

    def initialize(class_name, method_names = [])
      @class_name = root_name(class_name.to_s)

      method_names.each do |name|
        add_method(name.to_sym)
      end
    end

    def class_const
      @const ||= begin
                   Object.const_get(@class_name)
                 rescue NameError
                   @class_name.constantize
                 end
    end

    private

    def root_name(name)
      name.start_with?("::") ? name : "::#{name}"
    end

    def add_method(name)
      setter = "#{name}_method_name=".to_sym
      mapper = name

      (class << self; self; end).instance_eval do
        # Define the method to use the mapped method on the object.
        define_method name do |object|
          mapper.nil? ? nil : object.send(mapper)
        end

        # Define the method used to set the mapped method's name.
        define_method setter do |method_name|
          mapper = method_name.nil? ? nil : method_name.to_sym
        end
      end
    end

  end
end
