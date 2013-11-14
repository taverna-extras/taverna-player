module TavernaPlayer
  class RunPort < ActiveRecord::Base

    MAXIMUM_DATABASE_VALUE_SIZE = 255

    self.inheritance_column = "port_type"

    belongs_to :run, :class_name => "TavernaPlayer::Run"

    validates_presence_of :name
    validates_uniqueness_of :name, :scope => [:run_id, :port_type]

    attr_accessible :depth, :file, :name, :value

    has_attached_file :file,
      :path => File.join(TavernaPlayer.file_store, ":class/:attachment/:id/:filename"),
      :url => :file_url_via_run,
      :default_url => ""

    default_scope order("lower(name) ASC")

    # If there is both a value and a file, then prefer the file. If the file
    # is changed, delete the value. This must be run before "process_value"!
    before_save :delete_value, :if => :file_file_name_changed?

    # Overflow the value into a file if it is too big. Don't try to process
    # the value if the file has changed. This must run after "delete_value"!
    before_save :process_value, :if => :value_changed?, :unless => :file_file_name_changed?

    def display_name
      name.gsub('_', ' ')
    end

    def value_preview
      self[:value]
    end

    def value
      v = self[:value]
      if !v.blank? && !file.path.blank?
        File.read(file.path)
      else
        v
      end
    end

    private

    def delete_value
      self[:value] = nil
    end

    # If the value is too big to fit in the database then overflow it into a
    # file.
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
  end

  class RunPort::Input < RunPort

    private

    def file_url_via_run
      "/runs/#{run_id}/input/#{name}"
    end
  end

  class RunPort::Output < RunPort

    attr_accessible :metadata

    serialize :metadata

    private

    def file_url_via_run
      "/runs/#{run_id}/output/#{name}"
    end
  end
end
