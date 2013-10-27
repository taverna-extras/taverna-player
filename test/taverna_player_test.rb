require 'test_helper'

class TavernaPlayerTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, TavernaPlayer
  end

  test "taverna_player_hostname_setting" do
    TavernaPlayer.player_hostname = "https://example.com:8443/test/path"
    assert_equal TavernaPlayer.hostname[:scheme], "https", "Scheme not https"
    assert_equal TavernaPlayer.hostname[:host], "example.com:8443/test/path"
  end

  test "taverna server admin credentials" do
    TavernaPlayer.server_admin_username = "admin"
    TavernaPlayer.server_admin_password = "@Dm1|\|"
    assert_kind_of T2Server::HttpBasic, TavernaPlayer.server_admin_credentials
    assert_equal "admin", TavernaPlayer.server_admin_credentials.username
  end
end
