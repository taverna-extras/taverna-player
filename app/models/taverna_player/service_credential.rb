module TavernaPlayer
  class ServiceCredential < ActiveRecord::Base
    attr_accessible :description, :login, :name, :password,
      :password_confirmation, :uri

    validates :uri, :presence => true
    validates :login, :presence => true
    validates :password, :presence => true
    validates :password_confirmation, :presence => true
    validates :password, :confirmation => true
  end
end
