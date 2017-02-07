require 'sinatra'
require_relative "./simplifier/methods/def_master_transform.rb"
# require 'sinatra/reloader'

class C
  extend Transformation
end

get '/' do
  erb(:inter_input, {layout: :layout})
end

post '/result' do
  res = C.transform(params[:eq_input])
  # erb " <br>La liste est #{res}", layout: :layout

  # DEBUGGING BEGIN
  p "in ruby console, let's look at res"
  p res
  p "+++++++++++++++"
  # DEBUGGING END

  return res
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
    puts "----------"
    notice = "Your results are ready in file `./output.out`. Thanks!"
    puts notice
    return notice
  rescue StandardError => e
    2.times {puts ""}
    puts e
    puts "Please try again."
    return failure_notice = "#{e}, please try again."
  end

end
