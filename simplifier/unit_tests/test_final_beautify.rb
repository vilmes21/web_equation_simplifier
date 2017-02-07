require "minitest/autorun"
require_relative './TestHelpers'
require_relative '../def_final_beautify.rb'

class TestFinalBeautification < MiniTest::Test
  include TestHelpers
  include FinalBeautification

  def test_final_beautify
    test_exp = {
      "+3x-7" => "3x-7 = 0",
      "-y+8" => "-y+8 = 0",
      "-0+8" => "-0+8 = 0",
      "+y+8" => "y+8 = 0"
    }
    mass_assert(test_exp, :final_beautify)
  end
end
