
module TavernaPlayer
  class RunsController < TavernaPlayer::ApplicationController
    include TavernaPlayer::Concerns::Controllers::RunsController

    before_filter :override, :only => :index

    private

    def override
      @override = true
    end
  end
end
