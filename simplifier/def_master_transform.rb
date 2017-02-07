require_relative "./def_final_beautify.rb"
require_relative "./def_screen.rb"

module Transformation
  include FinalBeautification
  include Screen

  def transform(str)
    return screen(str) if screen(str)

    ugly_str = initial_uglify(str)
    terms = to_terms(ugly_str)
    count = count_terms(terms)
    polynomial_rebuilt = rebuild_polynomial(count)
    result = final_beautify(polynomial_rebuilt)

    nonsense(result) ? nonsense(result) : result
  end
end
