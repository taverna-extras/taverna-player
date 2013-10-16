class Workflow < ActiveRecord::Base
  attr_accessible :author, :description, :file, :title

  has_many :runs, :class_name => "TavernaPlayer::Run"

  def inputs
    workflow = File.open(file)
    model = T2Flow::Parser.new.parse(workflow)

    result = []
    model.sources.each do |i|
      description = i.descriptions.nil? ? "" : i.descriptions.join
      example = i.example_values.nil? ? "" : i.example_values.join
      result << { :name => i.name, :description => description,
        :example => example }
    end

    result
  end
end
