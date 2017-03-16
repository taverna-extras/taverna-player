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

  test "string looks like list" do
    refute is_string_list?(""), "Should not be detected as a list"
    refute is_string_list?("["), "Should not be detected as a list"
    refute is_string_list?("]"), "Should not be detected as a list"
    refute is_string_list?("]["), "Should not be detected as a list"
    refute is_string_list?("[[]"), "Should not be detected as a list"
    refute is_string_list?("[]]"), "Should not be detected as a list"
    refute is_string_list?("1"), "Should not be detected as a list"
    assert is_string_list?("[]"), "Should be detected as a list"
    assert is_string_list?(" \n[]"), "Should be detected as a list"
    assert is_string_list?("[] \n"), "Should be detected as a list"
    assert is_string_list?("[1]"), "Should be detected as a list"
    assert is_string_list?("[1, 2, 3]"), "Should be detected as a list"
    assert is_string_list?("[a a]"), "Should be detected as a list"
  end

  test "is string list method does not mangle inputs" do
    original = "[] "
    test = original.dup
    is_string_list?(test)
    assert_equal original, test, "Input string was modified"
  end

  test "parse string into list" do
    assert_equal [], parse_string_into_array("[]"),
      "String not parsed correctly"
    assert_equal ["a"], parse_string_into_array("[a]"),
      "String not parsed correctly"
    assert_equal ["1", "2", "3"], parse_string_into_array("[1, 2, 3]"),
      "String not parsed correctly"
    assert_equal ["1", "2", "3"], parse_string_into_array(" \n[1, 2, 3]"),
      "String not parsed correctly"
    assert_equal ["1", "2", "3"], parse_string_into_array("[1, 2, 3] \n"),
      "String not parsed correctly"
    assert_equal ["1 3"], parse_string_into_array("[1 3]"),
      "String not parsed correctly"
  end

  test "parse string into list method does not mangle inputs" do
    original = "[1, 2, 3] "
    test = original.dup
    parse_string_into_array(test)
    assert_equal original, test, "Input string was modified"
  end
end
