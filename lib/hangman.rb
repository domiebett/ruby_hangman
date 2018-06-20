require 'colorize'

# Return indexes of occurences of a character in a string
def find_indexes(needle, haystack)
  indexes = haystack.split("").map.with_index do |character, index|
    if character == needle
      index
    else
      next
    end
  end
  indexes.reject! { |c| c.nil? }
end

# Replace the character at a certain index
def replace_char_at_index(index, char, string)
  index.map do |index|
    string[index] = char
  end
  string
end

# Pick a random word from a txt file
def pick_random_word
  file_contents = File.readlines("words.txt");

  filtered_words = file_contents.select do |line|
    line.length.between?(5, 12)
  end

  filtered_words.sample.gsub!(/\s+/, "")
end

# Prints game progress
def print_game_progress(incomplete_word, incorrect_letters, limit, count)
  puts "#{"." * 50}"
  puts "\nWord         : #{incomplete_word}".blue
  puts "Attempts Left: #{limit - count}".blue
  unless incorrect_letters.empty?
    puts "Incorrect inputs: #{incorrect_letters.join(", ")}"
  end
  puts "#{"." * 50}"
end

# Checks if the input from user is a valid input
def is_valid_input(guess, incorrect_letters, incomplete_word)
  if guess.length > 1
    puts "\nOnly enter one character".red
    false
  elsif (incorrect_letters.include? guess) || (incomplete_word.include? guess)
    puts "\nYou have already entered that word".red
    false
  else
    true
  end
end

# Actual hangman game
def play_hangman
  secret_word = pick_random_word
  incomplete_word = "".rjust(secret_word.length, "_")
  incorrect_letters = []
  count = 0
  limit = 6

  loop do
    break if count >= limit || !(incomplete_word.include? "_")

    print_game_progress(incomplete_word, incorrect_letters, limit, count)

    print "\nEnter your guess: "
    guess = gets.chomp.to_s

    unless is_valid_input(guess, incorrect_letters, incomplete_word)
      next
    end

    if secret_word.include? guess
      indexes = find_indexes(guess, secret_word)
      incomplete_word = replace_char_at_index(indexes, guess, incomplete_word)
      puts "\nGreat. Keep going".green
    else
      puts "\nYou entered an incorrect letter. Please try again".red
      incorrect_letters.push(guess)
      count += 1
    end
  end

  !(incomplete_word.include? "_") ?
      puts("Congratulations, you won".green) :
      puts("\nYou failed to guess the words.".red)
end

puts "\nWelcome to the hangman game. Choose the letters to complete the word"

loop do
  play_hangman

  print "Would you like to play again? [y/n]: "
  break if (gets.chomp != "y")
end



