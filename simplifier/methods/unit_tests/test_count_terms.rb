require "minitest/autorun"
require_relative './TestHelpers'
require_relative '../def_count_terms.rb'

class TestCountTerms < MiniTest::Test
  include TestHelpers
  include CountTerms

  def test_not_const?
    rule = "As long as the expression doesn't contain letters, return true."
    test_exp = {
      "asjkasdfasd" => true,
      "-356x" => true,
      "xxyy" => true,
      "-000.3" => false,
      "+000.3" => false,
      "+" => false,
      "-" => false,
      "-356" => false
    }
    mass_assert(test_exp, :not_const?)
  end

  def test_parse_coeff
    test_exp = {
      "-7xyz" => "-7",
      "+7x^8y^-6z" => "+7",
      "+x^8y^-6z" => "+",
      "0x^8y^-6z" => "0",
      "02342x^8y^-6z" => "02342",
      "-02342x^8y^-6z" => "-02342",
      "-0x^8y^-6z" => "-0",
      "-xy^-33z^0" => "-"
    }
    mass_assert(test_exp, :parse_coeff)
  end

  def test_parse_var
    test_exp = {
      "-7xyz" => "xyz",
      "+7x^8y^-6z" => "x^8y^-6z",
      "+x^8y^-6z" => "x^8y^-6z",
      "0x^8y^-6z" => "x^8y^-6z",
      "02342x^8y^-6z" => "x^8y^-6z",
      "-02342x^8y^-6z" => "x^8y^-6z",
      "-0x^8y^-6z" => "x^8y^-6z",
      "-xy^-33z^0" => "xy^-33z^0"
    }
    mass_assert(test_exp, :parse_var)
  end

  def test_str_to_float
    test_exp = {
      "+" => 1.0,
      "+1" => 1.0,
      "-" => -1.0,
      "-1" => -1.0,
      "+345.385" => 345.385,
      "345.385" => 345.385,
      "+345.3850000000" => 345.385,
      "+0" => 0,
      "-0" => 0,
      "0" => 0,
      "-3257.8" => -3257.8
    }
    mass_assert(test_exp, :str_to_float)
  end

  def test_count_terms
    test_exp = {
      ["-9abba", "-100", "+8xyx^-1z", "-x^-3", "-90", "+7x^0y^0", "0xxxx"] => {"a^2b^2"=>-9.0, :constant=>-183.0, "yz"=>8.0, "x^-3"=>-1.0, "x^4"=>0.0},

      ["+0ab", "-3ab", "+22", "-22", "+100", "+3ab", "-20", "-80", "+50"] => {"ab"=>0.0, :constant=>50.0},

      ["-9a^0b", "+10b", "-xyz", "+zxy", "-20", "-20", "+a^2b^-5", "-b^-5a^2"] => {"b"=>1.0, "xyz"=>0.0, :constant=>-40.0, "a^2b^-5"=>0.0}
    }
    mass_assert(test_exp, :count_terms, true)
  end
end
