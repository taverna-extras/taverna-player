module TavernaPlayer
  class Run < ActiveRecord::Base
    include TavernaPlayer::Concerns::Models::Run
  end
end
