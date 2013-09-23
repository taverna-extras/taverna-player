require 'test_helper'

module TavernaPlayer
  class ApplicationHelperTest < ActionView::TestCase
    test "should output embedded run path" do
      id = 2
      path = new_embedded_run_path(id)
      assert path.include?("embedded=true"), "Path missing embedded=true"
      assert path.include?("workflow_id=#{id}"), "Path missing workflow_id"
      refute path.include?("http://"), "Path should not have a URI scheme"
    end

    test "should output embedded run url" do
      id = 2
      path = new_embedded_run_url(id)
      assert path.include?("embedded=true"), "Path missing embedded=true"
      assert path.include?("workflow_id=#{id}"), "Path missing workflow_id"
      assert path.include?("http://"), "Path missing a URI scheme"
    end
  end
end
