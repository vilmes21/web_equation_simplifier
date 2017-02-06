require_relative("./def_resolve_brackets.rb")

module InitialUglification
  include Brackets

  def add_plus_sign(str)
    (str=~ /^(-|\+)/) ? str : "+#{str}"
    #Aim: unless the str starts with - or + sign, always add a + sign.
  end

  def contains_negative_exp?(str)
    (str=~ /\^-/) ? true : false
  end

  def disguise_negative_exp(string)
    string.gsub("^-", "^NEGATIVE")
    # Aim: to avoid something like a^-7 being split.
  end

  def expose_negative_exp(string)
    string.gsub("^NEGATIVE", "^-")
  end

  def toggle_sign(string)
    string.gsub("+", "PLUS").gsub("-", "+").gsub("PLUS", "-")
  end

  def initial_uglify(str)
    no_space = str.gsub(" ", "")
    if contains_negative_exp?(no_space)
      no_space = disguise_negative_exp(no_space)
    end
    sides = no_space.split("=")
    left_raw = add_plus_sign(sides[0])
    left = (brackets_exist?(left_raw)) ? resolve_brackets(left_raw) : left_raw
    right_with_initial_sign = add_plus_sign(sides[1])
    right_raw = (brackets_exist?(right_with_initial_sign)) ? resolve_brackets(right_with_initial_sign) : right_with_initial_sign
    right = toggle_sign(right_raw)
    left + right
  end

  # INSTRUCTION: :initial_uglify takes in input_equation and move all monomials together, squeeze them, make sure they all have signs, and flip signs when needed. Return a string - a string that contains `NEGATIVE` if contains_negative_exp.
end
