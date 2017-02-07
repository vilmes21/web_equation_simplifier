require "minitest/autorun"
require_relative './TestHelpers'
require_relative '../def_master_transform.rb'

class TestTransformation < MiniTest::Test
  include TestHelpers
  include Transformation

  def fail_screening?(input)
    response = transform(input)
    halt_msg = "Program halted because the input"
    response.include?(halt_msg)
  end

  def test_transform_cause_halt
    test_exp = {
      "x+y = df^-" => true,
      "^x+y = df^-k" => true,
      "^=" => true,
      "^" => true,
      "^=fds" => true,
      "x=x" => true,
      "  =    " => true,
      "           " => true,
      "x=" => true,
      "a)=abc" => true,
      "(a=)=abc" => true,
      "(a-b)=a^bc" => true,
      "abc=abc" => true,
      "-abc=-   abc" => true,
      "(a))(=abc" => true,
      "(*a)=abc" => true,
      "(&a)=abc" => true,
      "($a)=abc" => true,
      "(a)^=abc" => true,
      "a^=abc" => true,
      "a8=abc" => true,
      "8= 8" => true,
      "8= 98" => true,
       "h30 =h^3" => true,
       "h^30 =h3a" => true,
       "-h^30 =-3a5" => true,
       "7b = 3^" => true,
       "778a^=17a" => true,
       "^778=17a" => true,
       "778a^a=17a" => true,
       "778a^()=17a" => true,
       "778a^=3" => true,
       "778a^-=17a" => true,
       "778a^+=17a" => true,
       "7b^2+(a)6=17a" => true,
       "7b^2+(a)b6=17a" => true,
       "abcd) = 3" => true,
       "abcd = (3" => true,
       "abcd = ((3" => true,
       "abcd = )3+4(" => true,
       "abc" => true,
       "abc=" => true,
       "=abc" => true,
       "a==bc" => true,
       "a==b=c" => true,
       "ab=c* " => true,
       "ab=c] " => true,
       "a{b}=c " => true,
       "a&b=c " => true,
       "a$b=c " => true,
       "a#b=c " => true,
       "a@b=c " => true,
       "a!b=c " => true,
       "a~b=c " => true,
       "a ` b=c " => true,
       "ab>=c " => true,
       "ab<=c " => true,
       "ab?=c " => true,
       "ab;=c " => true,
       "ab:=c " => true,
       "a/b=c " => true,
       "a[b=c " => true,
       "a% b=c " => true,
       "a_b=c " => true,
       "a | b=c " => true,
       "ab =   ab " => true,
       "- a       b =   -ab " => true,
       "9 =   9" => true,
       "-3 =- 3" => true,
       "h^-3 =h^- 3" => true,
       "h^+3 =h^+3" => true,

       "18xy^-2 + z -92a^-4b - pk+ 5y^-2zx = + 92bc - 3mn + j - 8tyu^9" => false,

        "xyz - ab^-7 -7hj = +99b^-7a -5zyx - 8" => false,

        "+ ab^-3c -34 + b^-9ca = 99 - xyz -y^8zx + y^4" => false,

        "5xy^-2 + z -2a^-4b^4 - pk+ 5y^-2zx = + 92bc - 3mn + j - 8tyu^9" => false,
    }

    mass_assert(test_exp, :fail_screening?)
  end
end
