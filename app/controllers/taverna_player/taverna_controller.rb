
module TavernaPlayer
  class TavernaController < TavernaPlayer::ApplicationController

    before_filter :connect_to_server

    def index
    end

    def update
    end

    private

    def connect_to_server
      server_uri = URI.parse(TavernaPlayer.server_address)
      conn_params = TavernaPlayer.server_connection
      @server = T2Server::Server.new(server_uri, conn_params)
    end
  end
end
