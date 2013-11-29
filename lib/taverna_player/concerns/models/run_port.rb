#------------------------------------------------------------------------------
# Copyright (c) 2013 The University of Manchester, UK.
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
      module RunPort

        extend ActiveSupport::Concern

        included do

          MAXIMUM_DATABASE_VALUE_SIZE = 255

          self.inheritance_column = "port_type"

          validates_presence_of :name
          validates_uniqueness_of :name, :scope => [:run_id, :port_type]

          attr_accessible :depth, :file, :metadata, :name, :value

          serialize :metadata

          has_attached_file :file,
            :path => File.join(TavernaPlayer.file_store, ":class/:attachment/:id/:filename"),
            :url => :file_url_via_run,
            :default_url => ""

          default_scope order("lower(name) ASC")

          # If there is both a value and a file, then prefer the file. If the
          # file is changed, delete the value. This must be run before
          # "process_value"!
          before_save :delete_value, :if => :file_file_name_changed?

          # Overflow the value into a file if it is too big. Don't try to
          # process the value if the file has changed. This must run after
          # "delete_value"!
          before_save :process_value, :if => :value_changed?,
            :unless => :file_file_name_changed?

          private

          def delete_value
            self[:value] = nil
          end

          # If the value is too big to fit in the database then overflow it
          # into a file.
          def process_value
            v = self[:value]

            if !v.blank? && v.size > MAXIMUM_DATABASE_VALUE_SIZE
              self[:value] = v[0...MAXIMUM_DATABASE_VALUE_SIZE]
              save_value_to_file(v)
            else
              self.file = nil unless file.path.blank?
            end
          end

          def save_value_to_file(v)
            Dir.mktmpdir("#{id}", Rails.root.join("tmp")) do |tmp_dir|
              tmp_file_name = File.join(tmp_dir, "#{name}.txt")

              File.write(tmp_file_name, v.force_encoding("UTF-8"))

              self.file = File.new(tmp_file_name)
            end
          end

        end # included

        def display_name
          name.gsub('_', ' ')
        end

        def value_preview
          self[:value]
        end

        def value
          v = self[:value]

          (!v.blank? && !file.path.blank?) ? File.read(file.path) : v
        end

      end
    end
  end
end
