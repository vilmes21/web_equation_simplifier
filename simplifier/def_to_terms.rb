require_relative "./def_initial_uglify.rb"

module ToTerms
  include InitialUglification

  def expose_negative_exp(string)
    string.gsub("^NEGATIVE", "^-")
  end

  def to_terms(str)
    str_with_delimiters = str.gsub("+", "DELIMITER+").gsub("-", "DELIMITER-")
    str_for_split = expose_negative_exp(str_with_delimiters)
    str_for_split.split("DELIMITER").slice(1..-1)
  end

  # INSTRUCTION: :to_terms takes in a string (this string may contain `NEGATIVE` if contains_negative_exp) and outputs an array of nicely split terms.
end
