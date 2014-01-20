#------------------------------------------------------------------------------
# Copyright (c) 2013, 2014 The University of Manchester, UK.
#
# BSD Licenced. See LICENCE.rdoc for details.
#
# Taverna Player was developed in the BioVeL project, funded by the European
# Commission 7th Framework Programme (FP7), through grant agreement
# number 283359.
#
# Author: Robert Haines
#------------------------------------------------------------------------------

module TavernaPlayer
  module Concerns
    module Utils

      extend ActiveSupport::Concern

      LIST_REGEX = Regexp.new('\A\[[^\[\]]*\]\z')

      # Taverna can have arbitrary (therefore effectively "infinite") port
      # depths so we need to recurse into them. This code is common across a
      # number of other modules.
      def recurse_into_lists(list, indexes)
        return list if indexes.empty? || !list.is_a?(Array)
        i = indexes.shift
        recurse_into_lists(list[i], indexes)
      end

      # Sometimes we need to test an array's depth to check that it matches a
      # port's depth. An empty list has depth 1, because it is a list.
      def list_depth(list, depth = 0)
        return depth if !list.is_a?(Array)
        list.empty? ? depth + 1 : list.map { |l| list_depth(l, depth + 1) }.max
      end

      # Can this string be parsed into an array? See LIST_REGEX above for
      # details.
      def is_string_list?(string)
        !LIST_REGEX.match(string.strip).nil?
      end

      # Parse a string into an array. This method assumes that the string has
      # been tested for conformance by the is_string_list? method first.
      def parse_string_into_array(string)
        string.strip[1...-1].split(',').map! { |i| i.to_s.strip }
      end

    end
  end
end
