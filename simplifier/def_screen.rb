require_relative "./def_resolve_brackets.rb"
require_relative "./def_count_terms.rb"

module Screen
  include Brackets
  include CountTerms

  def contains_exp?(str)
    (str=~ /\^/) ? true : false
  end

  def brackets_paired?(str)
    return false if str.length < 2
    str.scan(/\(/).size == str.scan(/\)/).size ? true : false
  end

  def brackets_disorder?(str)
    return false if !brackets_exist?(str)
    return true unless cl_index = locate_closing_bracket(str)
    if op_index = locate_openning_bracket(str, cl_index)
      str_debracked = rm_brackets(str, cl_index, op_index)
      brackets_disorder?(str_debracked)
    else
      return true
      # Aim: if cannot find openning_bracket, then the closing bracket must be misplaced.
    end
  end

  def eql_sign_bad?(str)
    return true if (str[0] == "=") || (str[-1] == "=")
    return true unless str.scan(/\=/).size == 1
    return false
  end

  def all_valid_minus_exp?(arr)
    arr.each do |a|
      return false unless a[1] == "-"
      return false if a[2]=~ /\D/
      # Aim: consider 6x^-ab. Need to ensure what follows the - sign is a clean digit.
    end
    true
  end

  def wrong_exp?(str)
    return true if str=~ /\^[a-zA-Z]/
    # If a letter follows ^ sign.
    return true if (str[-1] == "^") || (str[0] == "^")
    # If the first / last char of a str is ^.
    if str.length >= 2
      return true if (str[-2] == "^") && (str[-1]=~ /\D/)
    end
    # If the last char is not digit (such as brackets) and the 2nd last char is ^, it's surely missing exp num.
    erratic_exps = str.scan /\^\D./
    # Aim: array collections of these: ^- ^= ^a etc.
    if erratic_exps.empty?
      return false
      # Aim: if no sketchy-looking exps, there are surely no wrong exps.
    else
      return true unless all_valid_minus_exp?(erratic_exps)
      return false
    end
  end

  def has_illegal_chars?(str)
    return true if str=~ /(_|`|\[|\]|\/|\\|}|\||,|\>|\<)/
    # This ensures that _`][/  are illegal
    chars = str.scan(/([aA-zZ]|\(|\)|\d|\s|\=|\-|\+|\.)/)
    return true unless chars.size == str.length # This regex means we only accept digits, dots, -+=^ ()signs, and letters.
  end

  def screen(str)
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

    str = str.gsub(" ", "")
    return errors[:empty_str] if (str.empty? || str == "=")
    return errors[:brackets] unless brackets_paired?(str)
    str_copy = str.clone # Even if we use `str_copy = str`, it would mutate str. This way we do :brackets_disorder test without concern of accidental mutation.
    return errors[:brackets] if brackets_disorder?(str_copy)
    return errors[:eql_sign] if eql_sign_bad?(str)
    return errors[:illegal_chars] if has_illegal_chars?(str)

    left = str.split("=")[0]
    right = str.split("=")[1]
    if left == right
      return errors[:identity]
    elsif !not_const?(left) && !not_const?(right)
      return errors[:unequal]
    end

    return errors[:exp_sign_less] if str=~ /[a-zA-Z]\d/
    # Aim: contain a5

    if contains_exp? str
      return errors[:bracket_exp] if (str=~ /(\^\(|\^\))/)
      # Aim: contain ^( or ^)
      return errors[:base_less] if str[0] == "^" || str=~ /(\+\^|-\^|=\^|\d\^|\^\^|\(\^)/
      # Aim: this long regex basically covers all combinations between ^ sign and -+=(^
      return errors[:wrong_exp] if wrong_exp?(str)
    end

    return errors[:bracket_multiply] if str=~ /(\)\^|\d\(|\)\d|[a-zA-Z]\(|\)[a-zA-Z])/
    # Aim: contain )^ or 3( or )3 or a( or )a
    return false
  end

  def nonsense(str)
    situation = "No solution because the two sides of the equal sign"
    issues = {
      identity: "#{situation} are identical. ",
      unequal: "#{situation} cannot be equal."
    }
    return issues[:identity]  if str.gsub(" ", "") == "=0"
    return issues[:unequal] unless str=~ /[aA-zZ]/
  end
end
