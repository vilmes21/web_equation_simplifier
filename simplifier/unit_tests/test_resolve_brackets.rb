require "minitest/autorun"
require_relative './TestHelpers'
require_relative '../def_resolve_brackets.rb'

class TestBrackets < MiniTest::Test
  include TestHelpers
  include Brackets

  def test_locate_closing_bracket
    test_exp = {
      "+((3a^3-7)-(5+8))" => 9,
      "(3)+(3a^3-7)" => 2,
      "+(3a^3-7)" => 8
    }
    mass_assert(test_exp, :locate_closing_bracket)
  end

  def test_locate_openning_bracket
    test_exp = {
      ["+((3a^3-7)-(5+8))", 9] => 2,
      ["(3)+(3a^3-7)", 2] => 0,
      ["+(3a^3-7)", 8] => 1
    }
    mass_assert(test_exp, :locate_openning_bracket)
  end

  def test_need_toggle_signs?
    test_exp = {
      ["+((3a^3-7)-(5+8))", 2, 9] => false,
      ["(3)+(3a^3-7)", 0, 2] => false,
      ["-(3a^3-7)", 1, 8] => true
    }
    mass_assert(test_exp, :need_toggle_signs?)
  end

  def test_rm_brackets
    test_exp = {
      ["+((3a^3-7)-5+8)", 9, 2] => "+(3a^3-7-5+8)",
      ["(3)+(3a^3-7)", 2, 0] => "3+(3a^3-7)",
      ["-(3a^3-7)", 8, 1] => "-3a^3-7"
    }
    mass_assert(test_exp, :rm_brackets)
  end

  def test_brackets_exist?
    test_exp = {
      "kfasdjfks+7-8=op" => false,
      "-(sf)-8" => true
    }
    mass_assert(test_exp, :brackets_exist?)
  end


  def test_replace_substr
    test_exp = {
      ["Hardware is great", 0, 7, "Software"] => "Software is great",
      ["Software is great", 12, 16, "amazing"] => "Software is amazing"
    }
    mass_assert(test_exp, :replace_substr)
  end

  def test_resolve_brackets
    test_exp = {
      "-75-x+y-((ab+5)-bc+((((((((((((9)))))))))))))" => "-75-x+y-ab-5+bc-9",
      "-75-x+y-ab-5+bc-9" => "-75-x+y-ab-5+bc-9",
      "x+7-8+h^78" => "x+7-8+h^78",
      "-(8+a-(b+5+(x+y)))" => "-8-a+b+5+x+y",
      "-(a-(b^-3+(5x^0-(x+(y)))))" => "-a+b^-3+5x^0-x-y"
    }
    mass_assert(test_exp, :resolve_brackets)
  end
end
