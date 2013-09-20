
module TavernaPlayer
  class ServiceCredentialsController < TavernaPlayer::ApplicationController
    include TavernaPlayer::Concerns::Controllers::ServiceCredentialsController

    before_filter :override, :only => :index

    private

    def override
      @override = true
    end
  end
end
