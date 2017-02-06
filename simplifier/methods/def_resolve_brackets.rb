module Brackets
  def toggle_sign(string)
    string.gsub("+", "PLUS").gsub("-", "+").gsub("PLUS", "-")
  end

  def locate_closing_bracket(str)
    str =~ /\)/
  end

  def locate_openning_bracket(str, closing_bracket_index)
    while closing_bracket_index >= 0
      str[closing_bracket_index] == "(" ? (return closing_bracket_index) : (closing_bracket_index -= 1)
    end
  end

  def need_toggle_signs?(str, openning_bracket_index, closing_bracket_index)
    deciding_sign = (openning_bracket_index > 1) ? str[openning_bracket_index-1] : str[0]
    # Aim: If the openning_bracket is at 1, or even at 0, we simply need to see if str[0] is `-sign`; otherwise, we might end up wrongly checking str[-1] which means the last char of str.
    (deciding_sign == "-") ? true : false
  end

  def rm_brackets(str, closing_bracket_index, openning_bracket_index)
    str[closing_bracket_index] = ""
    str[openning_bracket_index] = ""
    str
  end

  def brackets_exist?(str)
    (str=~ /(\(|\))/) ? true : false
  end

  def replace_substr(str, start_index, end_index, new_substr)
    str[start_index..end_index] =  new_substr
    str
  end

  def resolve_brackets(str)
    return str unless brackets_exist?(str)
    # if no ) detected, then finish by returning the original str.
    closing_bracket_index = locate_closing_bracket(str)
    openning_bracket_index = locate_openning_bracket(str, closing_bracket_index) if closing_bracket_index # If closing_bracket does not even exist, then no need to search for openning.

    return "Program halted because your input did not properly open/close brackets." unless ( closing_bracket_index && openning_bracket_index)  # if only one of a pair of brackets exists, that means the input was not properly written.

    if need_toggle_signs?(str, openning_bracket_index, closing_bracket_index)
        old_content = str[(openning_bracket_index+1)... closing_bracket_index]
        toggled_content = toggle_sign(old_content)
        str_changed_content = replace_substr(str, openning_bracket_index+1, closing_bracket_index-1, toggled_content)
        str_sans_brackets = rm_brackets(str_changed_content, closing_bracket_index, openning_bracket_index)
    else
        # Aim: simply remove the brackets.
        str_sans_brackets = rm_brackets(str, closing_bracket_index, openning_bracket_index)
    end

    if brackets_exist?(str_sans_brackets)
      final_str = resolve_brackets(str_sans_brackets) # Aim: recurse once again if brackets_exist still.
    else
      final_str = str_sans_brackets
    end
  end

  # INSTRUCTION: This method must be used only AFTER ^-exp are disguised.
end
