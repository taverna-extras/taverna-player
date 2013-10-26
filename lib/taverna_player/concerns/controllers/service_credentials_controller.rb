
module TavernaPlayer
  module Concerns
    module Controllers
      module ServiceCredentialsController

        extend ActiveSupport::Concern

        included do
          respond_to :html

          before_filter :find_creds, :only => [ :index ]
          before_filter :find_cred, :except => [ :index, :new, :create ]

          private

          def find_creds
            @service_credentials = ServiceCredential.all
          end

          def find_cred
            @service_credential = ServiceCredential.find(params[:id])
          end
        end

        # GET /service_credentials
        def index

        end

        # GET /service_credentials/1
        def show

        end

        # GET /service_credentials/new
        def new
          @service_credential = ServiceCredential.new
        end

        # GET /service_credentials/1/edit
        def edit

        end

        # POST /service_credentials
        def create
          @service_credential = ServiceCredential.new(params[:service_credential])

          if @service_credential.save
            flash[:notice] = "Service credential was successfully created."
          end

          respond_with(@service_credential)
        end

        # PUT /service_credentials/1
        def update
          if @service_credential.update_attributes(params[:service_credential])
            flash[:notice] = "Service credential was successfully updated."
          end

          respond_with(@service_credential)
        end

        # DELETE /service_credentials/1
        def destroy
          if @service_credential.destroy
            flash[:notice] = "Service credential was deleted."
          end

          respond_with(@service_credential)
        end

      end
    end
  end
end
