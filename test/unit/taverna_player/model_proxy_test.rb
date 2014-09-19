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

class NameTest
  def proxy_method
    1
  end
end

class ModelProxyTest < ActiveSupport::TestCase

  setup do
    @name = "NameTest"
    @rooted_name = "::#{@name}"
    @constant = ::NameTest
    @methods = [ :test1, :test2 ]
  end

  test "name is rooted" do
    mp = TavernaPlayer::ModelProxy.new(@name)

    assert_equal @rooted_name, mp.class_name
    assert_equal @constant, mp.class_const
  end

  test "already rooted name" do
    mp = TavernaPlayer::ModelProxy.new(@rooted_name)

    assert_equal @rooted_name, mp.class_name
    assert_equal @constant, mp.class_const
  end

  test "proxy methods" do
    mp = TavernaPlayer::ModelProxy.new(@name, @methods)

    @methods.each do |method|
      setter = "#{method}_method_name=".to_sym
      assert mp.respond_to?(method)
      assert mp.respond_to?(setter)

      # Set the proxy method, then call it.
      mp.send(setter, :proxy_method)
      assert_equal 1, mp.send(method, NameTest.new)
    end
  end

end
