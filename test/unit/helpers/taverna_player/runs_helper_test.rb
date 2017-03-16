#------------------------------------------------------------------------------
# Copyright (c) 2013-2015 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

require 'test_helper'

module TavernaPlayer
  class RunsHelperTest < ActionView::TestCase
    include TavernaPlayer::Engine.routes.url_helpers

    setup do
      @int1 = taverna_player_interactions(:one)
      @int2 = taverna_player_interactions(:two)
    end

    test "should redirect internally" do
      redirect = interaction_redirect(@int1)
      refute redirect.blank?, "Redirect was blank."
      assert redirect.include?("/interaction/#{@int1.serial}"),
        "Redirect did not include interaction serial number"
    end

    test "should redirect externally" do
      redirect = interaction_redirect(@int2)
      refute redirect.blank?, "Redirect was blank."
      assert_equal redirect, @int2.page_uri,
        "Redirect did not match the page URI."
      refute redirect.include?("/interaction/#{@int2.serial}"),
        "Redirect included interaction serial number"
    end
  end
end
