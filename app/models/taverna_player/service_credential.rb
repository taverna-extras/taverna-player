module TavernaPlayer

  # This class represents a credential for authentication to a service during
  # a workflow run.
  class ServiceCredential < ActiveRecord::Base
    attr_accessible :description, :login, :name, :password,
      :password_confirmation, :uri

    validates :uri, :presence => true
    validates :login, :presence => true
    validates :password, :presence => true
    validates :password_confirmation, :presence => true
    validates :password, :confirmation => true

    ##
    # :method: description
    # :call-seq:
    #   description -> string
    #
    # The description of the service or credential.

    ##
    # :method: login
    # :call-seq:
    #   login -> string
    #
    # The login name (or user name) used to log in to the service.

    ##
    # :method: name
    # :call-seq:
    #   name -> string
    #
    # The name of the service.

    ##
    # :method: uri
    # :call-seq:
    #   uri -> string
    #
    # The URI of the service, returned as a string.

  end
end
