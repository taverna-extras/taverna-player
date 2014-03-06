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
  module Concerns
    module Models
      module RunPort

        extend ActiveSupport::Concern

        include TavernaPlayer::Concerns::Utils
        include TavernaPlayer::Concerns::Zip

        included do

          MAXIMUM_DATABASE_VALUE_SIZE = 255

          self.inheritance_column = "port_type"

          validates_presence_of :name
          validates_uniqueness_of :name, :scope => [:run_id, :port_type]

          #attr_accessible :depth, :file, :metadata, :name, :value

          serialize :metadata

          has_attached_file :file,
            :path => File.join(TavernaPlayer.file_store, ":class/:attachment/:id/:filename"),
            :url => :file_url_via_run,
            :default_url => ""
          do_not_validate_attachment_file_type :file

          default_scope { order("lower(name) ASC") }

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
              self[:value] = v[0...MAXIMUM_DATABASE_VALUE_SIZE].force_encoding("UTF-8")
              save_value_to_file(v)
            else
              self[:value] = v.force_encoding("UTF-8")
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

          def deep_value(index)
            # Need to mangle the path here in two ways:
            # * Files are indexed from 1 (not zero) in the output zip files.
            # * Errors are saved to a file with a '.error' suffix.
            path = index.map { |i| i + 1 }.join("/")
            path += ".error" if value_is_error?(index)

            read_file_from_zip(file.path, path)
          end

          def value_metadata(field, *indices)
            return if metadata.nil?
            index = [*indices].flatten
            recurse_into_lists(metadata[field], index)
          end

          def set_value_metadata(field, value)
            return unless depth == list_depth(value)

            md = metadata
            md = Hash.new if md.nil?
            md[field] = value
            update_attribute(:metadata, md)
          end

        end # included

        def display_name
          name.gsub('_', ' ')
        end

        def filename
          port_file = depth == 0 ? name : "#{name}.zip"
          "#{run.name}-#{port_file}"
        end

        def value_type(*indices)
          value_metadata(:type, *indices) || "text/plain"
        end

        def value_type=(type)
          set_value_metadata(:type, type)
        end

        def value_is_text?(*indices)
          type = value_type(*indices)
          type.starts_with?("text")
        end

        def value_is_error?(*indices)
          value_type(*indices) == "application/x-error"
        end

        def value_size(*indices)
          value_metadata(:size, *indices)
        end

        def value_size=(size)
          set_value_metadata(:size, size)
        end

        def value_preview
          self[:value]
        end

        def value(*indices)
          file_path = file.path
          if depth == 0
            if file_path.blank?
              self[:value]
            else
              value_is_text? ? File.read(file_path) : File.binread(file_path)
            end
          else
            index = [*indices].flatten
            index.empty? ? File.binread(file_path) : deep_value(index)
          end
        end

        def value=(v)
          self[:value] = v.force_encoding("BINARY")
        end

        def path(*indices)
          index = [*indices].flatten
          path = index.empty? ? "" : "/" + index.join("/")
          file_url_via_run + path
        end

      end
    end
  end
end
