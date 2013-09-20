
module TavernaPlayer
  module Concerns
    module Controllers
      module ServiceCredentialsController

        extend ActiveSupport::Concern

        included do
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
          respond_to do |format|
            format.html # index.html.erb
          end
        end

        # GET /service_credentials/1
        def show
          respond_to do |format|
            format.html # show.html.erb
          end
        end

        # GET /service_credentials/new
        def new
          @service_credential = ServiceCredential.new

          respond_to do |format|
            format.html # new.html.erb
          end
        end

        # GET /service_credentials/1/edit
        def edit

        end

        # POST /service_credentials
        def create
          @service_credential = ServiceCredential.new(params[:service_credential])

          respond_to do |format|
            if @service_credential.save
              format.html { redirect_to @service_credential,
                :notice => 'Service credential was successfully created.' }
            else
              format.html { render :action => "new" }
            end
          end
        end

        # PUT /service_credentials/1
        def update
          respond_to do |format|
            if @service_credential.update_attributes(params[:service_credential])
              format.html { redirect_to @service_credential,
                :notice => 'Service credential was successfully updated.' }
            else
              format.html { render :action => "edit" }
            end
          end
        end

        # DELETE /service_credentials/1
        def destroy
          @service_credential.destroy

          respond_to do |format|
            format.html { redirect_to service_credentials_url }
          end
        end

      end
    end
  end
end
