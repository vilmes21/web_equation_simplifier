require "minitest/autorun"
require_relative './TestHelpers'
require_relative '../def_to_terms.rb'

class TestToTerms < MiniTest::Test
  include TestHelpers
  include ToTerms

  def test_expose_negative_exp
    test_exp = {
      "-3x^NEGATIVE8" => "-3x^-8",
      "-6a^8-9b" => "-6a^8-9b"
    }
    mass_assert(test_exp, :expose_negative_exp)
  end

  def test_to_terms
    test_exp = {
      "+2x^NEGATIVE3-bc^7" => ["+2x^-3", "-bc^7"],
      "+44a^9bc^3de" => ["+44a^9bc^3de"],
      "-5x^0+7y^NEGATIVE11-goo" => ["-5x^0" , "+7y^-11", "-goo"]
    }
    mass_assert(test_exp, :to_terms)
  end
end
