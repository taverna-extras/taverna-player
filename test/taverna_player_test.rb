#------------------------------------------------------------------------------
# Copyright (c) 2013 The University of Manchester, UK.
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
