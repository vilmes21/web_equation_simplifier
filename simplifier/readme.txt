PROGRAM INSTRUCTIONS

This project is written in Ruby. To ensure the best results, please use Ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-darwin15].

To start the program, run the file `./entry.rb` in terminal / bash with the command `ruby entry.rb`. Other files will be properly required if their relative locations stay as current.

File `./entry.rb` covers command line prompts and calls methods from `./methods/def_master_transform.rb`. The `transform` method in turn requires other files for tool methods. Requiring continues as larger tools use smaller tools. The top lines of each file are indicative of where sources are located. Above all, the methods called in `transform` have indicative names that correspond closely to the file names.

The file `./input_eg.txt` is just an example of input file for the program's file mode.

In directory `./methods/unit_tests` are all the unit tests. All tests are Ruby minitests and can be confirmed by the same command `ruby name_of_file.rb`.
In total, there 9 test files consisting 426 assertion tests, broken down as below.

test_count = {
  "test_final_beautify.rb" => 4,
  "test_to_terms.rb" => 5,
  "test_resolve_brackets.rb" => 21,
  "test_initial_uglify.rb" => 27,
  "test_count_terms.rb" => 38,
  "test_organize_vars.rb" => 58,
  "test_master_transform.rb" => 75,
  "test_rebuid_polynomial.rb" => 92,
  "test_screen.rb" => 106,
}

Certain lines of comments are intentionally left for facilitating reading.

Hope you enjoy the program!
