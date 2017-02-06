require_relative "./methods/def_master_transform.rb"

class Mode
  include Transformation

  def mode_prompt
    puts "Type `i` for Interactive Mode, or `f` for File Mode:"
    mode = gets.chomp.gsub(" ", "").downcase
    if mode == "i"
      loop do
        5.times {puts ""}
        puts "YOU ARE IN INTERACTIVE MODE. PRESS CTRL+C TO QUIT."
        puts "Please type your input equation: "
        input = gets.chomp
        puts "----------"
        puts "Result:"
        puts transform(input)
      end
    elsif mode == "f"
      begin
        puts "Please provide the path to your input file (e.g. ./input.txt):"
        input_path = gets.chomp.gsub(" ", "")
        output = File.new("./output.out", "w")
        input_file = File.open(input_path, "r").each do |line|
            output.puts transform(line.chomp)
        end

        input_file.close
        output.close
        puts "----------"
        puts "Your results are ready in file `./output.out`. Thanks!"
      rescue StandardError => e
        2.times {puts ""}
        puts e
        puts "Please try again."
        mode_prompt
      end
    else
      puts "----------"
      puts "Sorry, your input was not recognized. Please try again."
      mode_prompt
    end
  end
end

puts "WELCOME TO AWESOME EQUATION SIMPLIFIER !!!"
Mode.new.mode_prompt
