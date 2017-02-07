require "minitest/autorun"
require_relative './TestHelpers'
require_relative '../def_screen.rb'

class TestScreen < MiniTest::Test
  include TestHelpers
  include Screen

  def test_brackets_paired?
    test_exp = {
      ")" => false,
      ")(" => true,
      "()" => true,
      "((()))" => true,
      "" => false,
      "(a)-(v)-c+(e)" => true,
      "(a))-(v)-c+(e)" => false
    }
    mass_assert(test_exp, :brackets_paired?)
  end

  def test_brackets_disorder?
    rule = "The method returns true if a bracket is missing a partner, or a ) is placed before (."
    test_exp = {
      ")" => true,
      ")(" => true,
      ")((((())))" => true,
      "(   ((())) () () ()" => true,
      ")   ((())) () () ()" => true,
      "((())) () () ()   )" => true,
      "((())) () () ()   (" => true,
      "((()))()   (    () ()   " => true,
      "()" => false,
      "((()))" => false,
      "" => false,
      "(a)-(v)-c+(e)" => false,
      "(a))-(v)-c+(e)" => true,
      "(a)()   )   )-(v)-c+(e)" => true,
      "sadfjskdfjkasdjfklasdfj" => false,
      "sadfjskdfjkasdjfklasdfj )" => true
    }
    mass_assert(test_exp, :brackets_disorder?)
  end

  def test_eql_sign_bad?
    rule = "The method returns true if the str begins / ends with = sign, or if more than one = sign appears, or if no = sign present."
    test_exp = {
      "sakfj" => true,
      "=sakfj" => true,
      "sakfj=" => true,
      "sakfj======" => true,
      "a=sd=kfj" => true,
      "a=sd=k===fj" => true,
      "a=sdkfj" => false,
    }
    mass_assert(test_exp, :eql_sign_bad?)
  end

  def test_all_valid_minus_exp?
    rule = "This method takes in an arr whose elements are all 3 chars long. Checks if the 2nd char of str is - sign. And if yes, what follows must be a digit. Else return false."
    test_exp = {
      ["^-f", "^-4", "^-(", "^-k"] => false,
      ["^+f", "^-4", "^+(", "^-k"] => false,
      ["^-8", "^-4", "^+4", "^-3"] => false,
      ["^-8", "^-4", "^-4", "^-3"] => true,
      ["^-0", "^-4", "^-4", "^-3"] => true
    }
    mass_assert(test_exp, :all_valid_minus_exp?, true)
  end

  def test_wrong_exp?
    test_exp = {
      "7^a" => true,
      "^778" => true,
      "778a^" => true,
      "778a^a" => true,
      "778a^)" => true,
      "778a^=)" => true,
      "778a^-)" => true,
      "778a^+)" => true,
      "778a+6" => false,
      "778a^-2+6" => false,
      "778b^-3c^-9a^-2+6" => false,
    }
    mass_assert(test_exp, :wrong_exp?)
  end

  def test_nonsense
    situation = "No solution because the two sides of the equal sign"
    issues = {
      identity: "#{situation} are identical. ",
      unequal: "#{situation} cannot be equal."
    }

    test_exp = {
      " = 0" => issues[:identity],
      "243 = 0" => issues[:unequal],
      "243x = 0" => nil,
      "-x = 0" => nil,
      "x = 0" => nil,
    }
    mass_assert(test_exp, :nonsense)
  end

  def test_screen
    event = "Program halted because the input"

    exp_usage = "In this program, the ^ sign may only be used right after a single letter. The exponent may only be an integer (please remove the + sign if it using a positive exponent)."

    coeff_usage = "A monomial in the program may and may only contain one coefficient, which must be placed at the left-most position, according to algebraic conventions. Unfortunately this program now does not yet support multiplification operations."

    errors = {
      brackets: "#{event} did not have properly placed brackets.",
      eql_sign: "#{event} did not properly use the = sign. An input equation should and should only contain one = sign, on both sides of which there should be expressions.",
      illegal_chars: "#{event} contained illegal characters. The only legal characters are letters, digits, dots, and +-=^)( signs.",
      identity: "#{event} has two idential sides.",
      exp_sign_less: "#{event} might have missed a ^ sign in one of the monomials. #{exp_usage} In case the input intended to use a coefficient? #{coeff_usage}",
      bracket_exp: "#{event} was either missing the exponent number or trying to illegally wrap exponent(s) in brackets. #{exp_usage}",
      wrong_exp: "#{event} did not have a proper exponent number after ^ sign. #{exp_usage}",
      base_less: "#{event} might be missing a base before ^ sign. #{exp_usage} #{coeff_usage}",
      empty_str: "#{event} is empty.",
      unequal: "#{event} can never have the two sides equal.",
      bracket_multiply: "#{event} was trying to illegally conduct multiplifications or exponentiations with content wrapped in brackets. #{exp_usage} #{coeff_usage}"
    }

    test_exp = {
      "     " => errors[:empty_str],
      "=" => errors[:empty_str],
      "abcd) = 3" => errors[:brackets],
      "abcd = (3" => errors[:brackets],
      "abcd = ((3" => errors[:brackets],
      "abcd = )3+4(" => errors[:brackets],
      "abcd = (3+4)" => false,
      "(ab+cd)+8 = (((3+4)))" => false,
      "abc" => errors[:eql_sign],
      "abc=" => errors[:eql_sign],
      "=abc" => errors[:eql_sign],
      "a==bc" => errors[:eql_sign],
      "a==b=c" => errors[:eql_sign],
      "ab=c* " => errors[:illegal_chars],
      "ab=c] " => errors[:illegal_chars],
      "a{b}=c " => errors[:illegal_chars],
      "a&b=c " => errors[:illegal_chars],
      "a$b=c " => errors[:illegal_chars],
      "a#b=c " => errors[:illegal_chars],
      "a@b=c " => errors[:illegal_chars],
      "a!b=c " => errors[:illegal_chars],
      "a~b=c " => errors[:illegal_chars],
      "a ` b=c " => errors[:illegal_chars],
      "ab>=c " => errors[:illegal_chars],
      "ab<=c " => errors[:illegal_chars],
      "ab?=c " => errors[:illegal_chars],
      "ab;=c " => errors[:illegal_chars],
      "ab:=c " => errors[:illegal_chars],
      "a/b=c " => errors[:illegal_chars],
      "a[b=c " => errors[:illegal_chars],
      "a% b=c " => errors[:illegal_chars],
      "a_b=c " => errors[:illegal_chars],
      "a | b=c " => errors[:illegal_chars],
      "ab =   ab " => errors[:identity],
      "- a       b =   -ab " => errors[:identity],
      "9 =   9" => errors[:identity],
      "-3 =- 3" => errors[:identity],
      "h^-3 =h^- 3" => errors[:identity],
      "h^+3 =h^+3" => errors[:identity],
      "h^30 =h^3" => false,
      "h^30 =h3a" => errors[:exp_sign_less],
      "-h^30 =-3a5" => errors[:exp_sign_less],
      "a=5" => false,
      "a=54" => false,
      "a=54345" => false,
      "7b = 3^" => errors[:base_less],
      "778a^=17a" => errors[:wrong_exp],
      "^778=17a" => errors[:base_less],
      "778a^a=17a" => errors[:wrong_exp],
      "778a^()=17a" => errors[:bracket_exp],
      "778a^=3" => errors[:wrong_exp],
      "778a^-=17a" => errors[:wrong_exp],
      "778a^+=17a" => errors[:wrong_exp],
      "7b^2+(a)6=17a" => errors[:bracket_multiply],
      "7b^2+(a)b6=17a" => errors[:exp_sign_less],
    }
    mass_assert(test_exp, :screen)
  end
end
