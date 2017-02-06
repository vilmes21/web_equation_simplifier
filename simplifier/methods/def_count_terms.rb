require_relative "./def_to_terms.rb"
require_relative "./def_organize_vars.rb"

module CountTerms
  include ToTerms
  include OrganizeVars

  def not_const?(str)
    (str=~ /[a-zA-Z]/) ? true : false
    # Regex here unfortunately includes ^][\` (Recheck)
  end

  def parse_coeff(str)
    # Aim: take in a str, return its coefficient with - or + sign
    index = index_of_1st_var(str)
    str.slice(0...index)
  end

  def parse_var(str)
    index = index_of_1st_var(str)
    str.slice(index..-1)
  end

  def str_to_float(str)
    # Aim: to turn numbers of str format into actual math numbers e.g. "1.3" to 1.3
    return 1.0 if str == "+"
    return -1.0 if str == "-"
    str.to_f
  end

  def count_terms(arr)
    count = Hash.new(0)

    arr.each do |messy_term|
      if not_const?(messy_term)
        messy_vars = parse_var(messy_term)
        organized_vars = organize_vars(messy_vars)

        organized_vars = :constant unless not_const?(organized_vars)

        coeff = str_to_float(parse_coeff(messy_term))

      else
        coeff = str_to_float(messy_term)
        organized_vars = :constant
      end
      count[organized_vars] += coeff
    end

    count
  end

  # INSTRUCTION: :count_terms takes in an arr of messy terms (all terms begin with either - or +), organizes all of their variable part. Return a hash of organized variable parts pointing to their coefficients (including :constant).
end
