require "minitest/autorun"
require_relative '../def_initial_uglify'
require_relative './TestHelpers'

class TestInitialUglification < MiniTest::Test
  include TestHelpers
  include InitialUglification

  def test_add_plus_sign
    exp = %w(+00 -1 -ab^3+7 +string_here -no_change)
    tests = %w(00 -1 -ab^3+7 string_here -no_change)
    test_exp = {}
    tests.each_with_index do |test, i|
      test_exp[test] = exp[i]
    end
    mass_assert(test_exp, :add_plus_sign)
  end

  def test_contains_negative_exp?
    exp = %w(false false false true true).map {|x| to_bool(x)}
    tests = %w(00 -1 -ab^3+7 bc^-7d a^-0b)
    test_exp = {}
    tests.each_with_index do |test, i|
      test_exp[test] = exp[i]
    end
    mass_assert(test_exp, :contains_negative_exp?)
  end

  def test_disguise_negative_exp
    exp = %w(ac^8 -b^NEGATIVE3x xyz^NEGATIVE0 h^7)
    tests = %w(ac^8 -b^-3x xyz^-0 h^7)
    test_exp = {}
    tests.each_with_index do |test, i|
      test_exp[test] = exp[i]
    end
    mass_assert(test_exp, :disguise_negative_exp)
  end
  #
  def test_expose_negative_exp
    exp = %w(ac^8 -b^-3x xyz^-0 h^7)
    tests = %w(ac^8 -b^NEGATIVE3x xyz^NEGATIVE0 h^7)
    test_exp = {}
    tests.each_with_index do |test, i|
      test_exp[test] = exp[i]
    end
    mass_assert(test_exp, :expose_negative_exp)
  end

  def test_toggle_sign
    rule = "It only toggles signs that are explicitly written. Implicit + signs must be mannually written before calling :toggle_sign."
    exp = %w(+a-b+c x-y-z q+w-e)
    tests = %w(-a+b-c x+y+z q-w+e)
    test_exp = {}
    tests.each_with_index do |test, i|
      test_exp[test] = exp[i]
    end
    mass_assert(test_exp, :toggle_sign)
  end

  def test_initial_uglify
    exp = [
      "-5x^2-8-3abc", "+7-9+ab^NEGATIVE2n-5t-8", "+t^NEGATIVE3-yu+6-33", "+aksfjkas-66kk-3r-7b+4+6y+aksfj-234ks^7-98+xyz+3", "+8ak^3sfjkas+3aks^6fj-234ks^NEGATIVE7-98+xyz",
      "-8ak^NEGATIVE3sfj^NEGATIVE2ka-8s+3aks^6fj-234ks^NEGATIVE7+98+xyz"
    ]
    tests = [
      "-  5x ^2  -8      =  3abc",
      "7-9+a  b^-2 n= +5   t+8", "t  ^-3   -y  u+6   =+33", "(aksfjkas-66kk-(3r+7b-(4+6y)))    + (aksfj -234ks^7) = 98 - (xyz + 3)",
      "8ak^3sfjkas    + 3aks^6fj -234ks^-7 = 98 - xyz",
      "-8ak^-3sfj^-2ka-8s    + 3aks^6fj -(234ks^-7) = -98 - xyz"
    ]
    test_exp = {}
    tests.each_with_index do |test, i|
      test_exp[test] = exp[i]
    end
    mass_assert(test_exp, :initial_uglify)
  end
end
