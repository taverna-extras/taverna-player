require 'test_helper'

class TavernaPlayerTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, TavernaPlayer
  end

  test "extra mime types present" do
    ["application/x-error", "application/x-empty", "inode/x-empty"].each do |type|
      assert_not_empty MIME::Types[type], "MIME type '#{type}' missing"
    end
  end
end
