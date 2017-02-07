require 'sinatra'
require_relative "./simplifier/def_master_transform.rb"

class C
  extend Transformation
end

get '/' do
  erb(:inter_input, {layout: :layout})
end

post '/result' do
  return C.transform(params[:eq_input])
end

post '/file_result' do
  begin
    input_path = params[:file_path].chomp.gsub(" ", "")
    output = File.new("./output.out", "w")
    input_file = File.open(input_path, "r").each do |line|
        output.puts C.transform(line.chomp)
    end
    input_file.close
    output.close
    return "Your results are ready in file `./output.out`. Thanks!"
  rescue StandardError => e
    return "#{e}, please try again."
  end
  # closing `begin-rescue`
end
# closing `post file_result`
