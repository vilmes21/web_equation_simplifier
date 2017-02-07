require "minitest/autorun"
require_relative './TestHelpers'
require_relative '../def_rebuild_polynomial.rb'

class TestRebuilding < MiniTest::Test
  include TestHelpers
  include Rebuilding

  def test_rm_ending_zero
    exp_arr = [0.2, -0.2, -0.255, -0.255, -4.255, 4.255, 0, 0, 0, 0, 0, 23, 23, -23, -2300, -2300, -2300.98, -1, 1, 1, 10]

    test_arr = [0.2000, -0.2000, -0.255, -0.2550000, -4.2550000, 4.2550000, -0.000, +0.000, +0, 0, -0, +23, 23, -23, -2300, -2300.00, -2300.98, -1, +1, 1, 10]

    arr_mass_assert(exp_arr, test_arr, :rm_ending_zero)
  end

  def test_str_clean_num
    exp_arr = ["0", "0", "0", "0", "-5", "-5.7", "-5.7", "+5.7", "+5.7", "+5.7", "+5.7", "+10", "+10", "-10", "-10", "-1", "-1", "+1", "+1", "+1", "+1.001"]

    test_arr = [0, 0.000, -0.000, -0, -5, -5.7, -5.7000, +5.7, +5.7000, 5.7, 5.700, 10, 10.0000, -10, -10.000, -1.000, -1, +1, 1, 1.00, 1.001]

    arr_mass_assert(exp_arr, test_arr, :str_clean_num)
  end

  def test_float_to_str
    test_arr = [-5, -5.7, -5.7000, +5.7, +5.7000, 5.7, 5.700, 10, 10.0000, -10, -10.000, 0, 0.000, -0.000, -0, -1.000, -1, +1, 1, 1.00, 1.001]

    exp_arr = ["-5", "-5.7", "-5.7", "+5.7", "+5.7", "+5.7", "+5.7", "+10", "+10", "-10", "-10", "", "", "", "", "-", "-", "+", "+", "+", "+1.001"]

    arr_mass_assert(exp_arr, test_arr, :float_to_str)
  end

  def test_const_to_str
    test_arr = [-5, -5.7, -5.7000, +5.7, +5.7000, 5.7, 5.700, 10, 10.0000, -10, -10.000, -1.000, -1, +1, 1, 1.00, 1.001, 0, +0, 0.000, +0.000, -0.000, -0]

    exp_arr = ["-5", "-5.7", "-5.7", "+5.7", "+5.7", "+5.7", "+5.7", "+10", "+10", "-10", "-10", "-1", "-1", "+1", "+1", "+1", "+1.001", "", "", "", "", "", ""]

    arr_mass_assert(exp_arr, test_arr, :const_to_str)
  end

  def test_rebuild_polynomial
    rule = "Takes in a hash. None of the keys of the hash should have - or + signs because they count as coefficients. The result str will always starts with - or + sign."
    test_exp = {
      {"a^2b^2"=>-9.0, :constant=>-173.0, "yz"=>8.0, "x^-3"=>-1.0, "x^4"=>0.0} => "-9a^2b^2-x^-3+8yz-173",

      {"a^-2"=>-9.0,  "y"=>8.0, "x^4"=>0.0} => "-9a^-2+8y",

      {"a^0"=>-9.0,  "y"=>8.0, "x^4"=>0.0} => "-9a^0+8y",

      {"a^0"=>0.0,  "y"=>0.0, "x^4"=>0.0, :constant => 560 } => "+560",

      {"a^0"=>0.0,  "ysfa"=>0.0, "x^4"=>0.0, :constant => 0.0 } => "",

      {"x^007"=>9.0000,  "y"=>0.0, "dfjksfjx^4"=>0.0} => "+9x^007"
    }
    mass_assert(test_exp, :rebuild_polynomial, true)
  end
end
