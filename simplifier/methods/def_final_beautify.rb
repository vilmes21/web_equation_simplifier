require_relative "./def_rebuild_polynomial.rb"

module FinalBeautification
  include Rebuilding
  
  def final_beautify(str)
    str = str[1..-1] if str[0] == "+"
    str += " = 0"
  end
end
