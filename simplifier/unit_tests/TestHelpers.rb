module TestHelpers

  def mass_assert(test_exp_hash, method_as_symbol, test_arr_as_1_arg=false)
    test_exp_hash.each do |test, exp|
      test = "#{test}" if test.is_a? String
      # Aim: since strings as hash keys are frozen, we have to make an unfrozen copy for our test purposes.
      if test_arr_as_1_arg
        assert_equal exp, send(method_as_symbol, test)
      else
        assert_equal exp, send(method_as_symbol, *test)
        # Aim: when test_arr_as_1_arg is manually set to true, the * sign ensure that this `test` may be one string, or one array of multiple elements.
      end
    end
  end

  def arr_mass_assert(exp_arr, test_arr, method_as_symbol)
    exp_arr.each_with_index do |exp, i|
      assert_equal exp, send(method_as_symbol, test_arr[i])
    end
  end

  def to_bool(str)
      return true if str=="true"
      return false if str=="false"
      return nil
  end

end
