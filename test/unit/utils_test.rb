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

  test "recurse into list" do
    test_list1 = [0, 1, 2, 3, 4]
    test_list2 = [[0, 1], [2, 3], [4, 5]]

    assert_equal 0, recurse_into_lists(0, [0, 0]),
      "A non-list should just be returned unchanged."
    assert_equal test_list1, recurse_into_lists(test_list1, []),
      "With no indices the original list should be returned unchanged."
    assert_equal 0, recurse_into_lists(test_list1, [0]), "Should return 0."
    assert_equal 4, recurse_into_lists(test_list1, [4]), "Should return 4."
    assert_equal 0, recurse_into_lists(test_list2, [0, 0]), "Should return 0."
    assert_equal [0, 1], recurse_into_lists(test_list2, [0]),
      "Should return [0, 1]."
    assert_equal 5, recurse_into_lists(test_list2, [2, 1]), "Should return 5."
  end

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
