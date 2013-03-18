module TavernaPlayer

  # This only knows about t2flow now, but will know about scufl2 in future
  class Parser

    def Parser.parse(workflow)
      if workflow.is_a? String
        workflow = File.open(workflow) if File.exist? workflow
      end

      Model.new(T2Flow::Parser.new.parse(workflow))
    end
  end

  # This only knows about t2flow now, but will know about scufl2 in future
  class Model
    def initialize(model, type = :t2flow)
      @model = model
      @type = type
    end

    def inputs
      case @type
      when :t2flow
        inputs = []
        @model.sources.each do |i|
          description = i.descriptions.nil? ? "" : i.descriptions.join
          example = i.example_values.nil? ? "" : i.example_values.join
          inputs << { :name => i.name, :description => description,
            :example => example }
        end
        inputs
      end
    end
  end
end
