require "minitest/autorun"
require_relative './TestHelpers'
require_relative '../def_organize_vars.rb'

class TestOrganizeVars < MiniTest::Test
  include TestHelpers
  include OrganizeVars

  def test_index_of_1st_var
    rule = "No need to check `][/_ signs since :has_illegal_chars will handle those"
    test_exp = {
      "xyz" => 0,
      "+xyz" => 1,
      "-xyz" => 1,
      "3xyz" => 1,
      "0xyz" => 1,
      "-0xyz" => 2,
      "+0xyz" => 2,
      "Ayz" => 0,
      "+Ayz" => 1,
      "-Ayz" => 1,
      "3Ayz" => 1,
      "0Ayz" => 1,
      "-0Ayz" => 2,
      "+0Ayz" => 2,
      "xBz" => 0,
      "+xBz" => 1,
      "-xBz" => 1,
      "3xBz" => 1,
      "0xBz" => 1,
      "-0xBz" => 2,
      "+0xBz" => 2,
    }
    mass_assert(test_exp, :index_of_1st_var)
  end

  def test_contains_exp?
    test_exp = {
      "adkjk+8" => false,
      "^aaab-9" => true,
      "aaab-9" => false,
      "aaab^-3" => true,
      "aa^7ab^0" => true,
      "ab^0" => true,
    }
    mass_assert(test_exp, :contains_exp?)
  end

  def test_create_order_arr
    rule = "Input a hash of letters or letter groups. Output array has letters sorted alphabetically and does not contain key :constant."
    test_exp = {
      {a: 34, c: 23, b: "good"} => [:a, :b, :c],
      {a: 34, constant: 98, c: 23, b: "good"} => [:a, :b, :c],
      {"a^8"=> 34, :constant=> 98, "c^0"=> 23, "b^-3"=> "good"} => ["a^8", "b^-3", "c^0"]
    }
    mass_assert(test_exp, :create_order_arr, true)
  end

  def test_count_letter_exp
    test_exp = {
      ["a", "a", "a", "b", "b", "b", "c", "c", "c"] => {"a"=>3, "b"=>3, "c"=>3},

      "xyzxyz".split("") => {"x"=>2, "y"=>2, "z"=>2},

      %w(d e f d e f) => {"d"=>2, "e"=>2, "f"=>2}
    }
    mass_assert(test_exp, :count_letter_exp, true)
  end

  def test_value_all_zeros?
    test_exp = {
      {"d"=>0, "e"=>0, "f"=>0} => true,
      {"d"=>-0, "e"=>-0, "f"=>0} => true,
      {"d"=>2, "e"=>2, "f"=>2} => false,
      {"d"=>2, "e"=>2, "f"=>0} => false,
      {"d"=>0, "e"=>2, "f"=>-3} => false,
    }
    mass_assert(test_exp, :value_all_zeros?, true)
  end

  def test_rebuild_monomial_sans_coeff
    test_exp = {
      {"a" => 0, "b" => 1, "c" => -1} => "bc^-1",
      {"x" => 1, "b" => 1, "c" => 1} => "bcx",
      {"a" => 0, "b" => 0, "c" => 0} => "1",
      {"c" => 4, "b" => 3, "a" => 2} => "a^2b^3c^4",
    }
    mass_assert(test_exp, :rebuild_monomial_sans_coeff, true)
  end

  def test_contains_coeff?
    rule = "check if the beginning of input str is - + or a digt."
    test_exp = {
      "-ab" => true,
      "bcd" => false,
      "+ef" => true,
      "+0ef" => true,
      "43ef" => true,
      "-1ef" => true,
      "+1ef" => true,
      "-3ef" => true,
      "(w)" => false
    }
    mass_assert(test_exp, :contains_coeff?)
  end

  def test_organize_vars
    rule = "The input of this method should not contain coefficients."
    test_exp = {
      "axdaaa^-100a^-23d^-99" => "a^-120d^-98x",
      "acb^0xy" => "acxy",
      "ab^3c^0" => "ab^3",
      "c^0d^0" => "1",
      "bb^8aaa" => "a^3b^9",
      "c^-1ba^0" => "bc^-1",
      "ca^-2b^8" => "a^-2b^8c",
      "c^-1b^1a^0" => "bc^-1"
    }
    mass_assert(test_exp, :organize_vars)
  end

end
