require_relative "./def_count_terms.rb"

module Rebuilding
  include CountTerms

  def rm_ending_zero(float)
    (float == float.floor) ? float.to_i : float
  end

  def str_clean_num(float)
    clean_num = rm_ending_zero(float)
    clean_num > 0 ? "+#{clean_num}" : "#{clean_num}"
  end

  def float_to_str(float)
    # Aim: to prepare proper string coeff to be combined with variable part. Returned string should always begin with - or +, except empty string (0).
    return "" if float == 0
    return "+" if float == 1
    return "-" if float == -1
    str_clean_num(float)
  end

  def const_to_str(float)
    # This method is not repeating :float_to_str. Key difference: :const_to_str allows all numbers (especially 1) to be shown as str except 0 as emptiness.
    float == 0 ? "" : str_clean_num(float)
  end

  def rebuild_polynomial(hash_count)
    polynomial_rebuilt = ""

    order = create_order_arr(hash_count)
    # This step removed :constant key if applicable

    order.each do |vars|
        if hash_count[vars] == 0
          piece = ""
        else
          piece = "#{float_to_str(hash_count[vars])}#{vars}" #float_to_str will deal with signs.
        end
        polynomial_rebuilt += piece
    end

      hash_count[:constant] ? (polynomial_rebuilt += const_to_str(hash_count[:constant])) : polynomial_rebuilt
  end

  # INSTRUCTION: Notice the hash passed into :rebuild_polynomial has all keys without signs!!! Becuz the signs are with their coeff.
end
