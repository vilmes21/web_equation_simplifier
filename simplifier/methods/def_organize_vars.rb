module OrganizeVars
  def index_of_1st_var(str)
    str=~ /[aA-zZ]/
  end

  def parse_coeff(str)
    index = index_of_1st_var(str)
    coeff = str.slice(0...index)
  end

  def parse_var(str)
    index = index_of_1st_var(str)
    var_part = str.slice(index..-1)
  end

  def contains_exp?(str)
    (str=~ /\^/) ? true : false
  end

  def create_order_arr(hash)
    (hash.keys - [:constant]).sort
    # Aim: To sort var_part alphabetically, but excluding the key :constant (in case it contains :constant; if not, it does not hurt)
  end

  def count_letter_exp(arr)
    # Aim: takes an arr of letters and returns a hash with each letter's exponent count.
    count = Hash.new(0)
    arr.each {|elem| count[elem] += 1}
    count
  end

  def value_all_zeros?(hash)
    hash.each_value {|v| return false unless v == 0}
    true
  end

  def rebuild_monomial_sans_coeff(hash_count)
    # `hash_count` is the hash list of exponents of their corresponding letters. `order` is an array, sorted alphabetically.
    order = create_order_arr(hash_count)
    if value_all_zeros?(hash_count)
      term_rebuilt = "1"
      # Aim:  i.e. a^0x^0 == 1. However, if one of the arr element is a letter with 1 or more as the exponent, then proceed to `else`
    else
      term_rebuilt = ""
      order.each do |va|
          if hash_count[va] == 1
            piece = va
          elsif hash_count[va] == 0
            piece = ""
          else
            piece = "#{va}^#{hash_count[va]}"
          end
          term_rebuilt += piece
      end
    end
    term_rebuilt
  end

  def contains_coeff?(str)
    (str=~ /^(\d|-|\+)/) ? true : false
    # Aim: check if the beginning of input str is - + or a digt.
  end

  def organize_vars(messy_vars)
    return "Program halted because your argument still contains coefficient. Please try again by passing in a properly parsed messy_vars string." if contains_coeff?(messy_vars)

    if contains_exp?(messy_vars)
      letters_with_exp = messy_vars.scan(/[a-zA-Z]\^-?\d+/)

      letter_count = Hash.new(0)
      letters_with_exp.each do |let|
        messy_vars = messy_vars.gsub(let, "")
        # Aim: delete these pieces from str.
        letter_count[let[0]] += (let[2..-1].to_i)
      end

      unless messy_vars.empty?
        letters_sans_exp = messy_vars.split("")
        letters_sans_exp.each {|let| letter_count[let] += 1}
      end
      # Aim: count letters_sans_exp after having considered letters_with_^ sign
      letter_count
    else
      letter_count = count_letter_exp(messy_vars.split("")) # Aim: if no ^ is present, like `abcd`, split and count right away
    end

    rebuild_monomial_sans_coeff(letter_count)
  end

  # INSTRUCTION: :organize_vars takes in a str but this str must not contain coeff. Returns one str that is ordered, organized, but has no coefficient, such as `bb^8aaa` into `a^3b^9`
end
