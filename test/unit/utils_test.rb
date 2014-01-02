#------------------------------------------------------------------------------
# Copyright (c) 2014 The University of Manchester, UK.
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

class UtilsTest < ActiveSupport::TestCase

  include TavernaPlayer::Concerns::Utils

  test "list depth" do
    assert_equal 0, list_depth(1), "Non-list should have depth 0."
    assert_equal 1, list_depth([]), "Empty list should have depth 1."
    assert_equal 1, list_depth([0]), "Should have depth 1."
    assert_equal 1, list_depth([0, 1, 2, 3]), "Should have depth 1."
    assert_equal 2, list_depth([[]]), "Should have depth 2."
    assert_equal 2, list_depth([0, []]), "Should have depth 2."
    assert_equal 2, list_depth([[0], [1], [2]]), "Should have depth 2."
    assert_equal 2, list_depth([0, [1], [2]]), "Should have depth 2."
    assert_equal 10, list_depth([[[[[[[[[[]]]]]]]]]]), "Should have depth 10."
  end
end
