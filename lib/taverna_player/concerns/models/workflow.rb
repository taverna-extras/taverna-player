#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
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
  module Concerns
    module Models
      module Workflow

        extend ActiveSupport::Concern

        included do
          # attr_accessible :author, :description, :file, :title

          has_many :runs, :class_name => "TavernaPlayer::Run"
        end # included

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
    end
  end
end
