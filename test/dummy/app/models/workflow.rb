class Workflow < ActiveRecord::Base
  attr_accessible :author, :description, :file, :title
end
