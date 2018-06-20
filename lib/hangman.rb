
class HangMan

  def initialize(file = "words.txt")
    @file_contents = File.readlines(file)
    @words = proper_length_words
    @secret_word = pick_random_word.downcase
    @incomplete_word = generate_incomplete_word
    @incorrect_guesses = []
    @limit = 6
  end

  # Actual gameplay
  def play
    count = 0
    loop do
      break if count >= @limit || !(@incomplete_word.include? "_")

      print_game_progress(count)

      print "\nEnter your guess: "
      guess = gets.chomp.to_s.downcase

      unless is_valid_guess? guess
        next
      end

      if @secret_word.include? guess
        fill_correct_guess(guess)
        puts "\nGreat. Keep going"
      else
        puts "\nYou entered an incorrect letter. Please try again"
        @incorrect_guesses.push(guess)
        count += 1
      end
    end

    generate_results
  end

  # If guess is correct fill the correct characters in the word to guess
  def fill_correct_guess(guess)
    indexes = find_guess_position(guess)
    indexes.map do |index|
      @incomplete_word[index] = guess
    end
  end

  # Find the position of the guess in the secret word
  def find_guess_position(needle)
    get_index = lambda { |character, index| index if character == needle }
    indexes = @secret_word.split("").map.with_index(&get_index).reject { |c| c.nil? }
  end

  # Print the game progress
  def print_game_progress(count)
    puts "#{"." * 50}"
    puts "\nWord         : #{@incomplete_word}"
    puts "Attempts Left: #{@limit - count}"
    unless @incorrect_guesses.empty?
      puts "Incorrect inputs: #{@incorrect_guesses.join(", ")}"
    end
    puts "#{"." * 50}"
  end

  # Generates dashes with same length as the secret word
  def generate_incomplete_word
    "".rjust(@secret_word.length, "_")
  end

  # Display if player has won or lost
  def generate_results
    !(@incomplete_word.include? "_") ?
        puts("Congratulations, you won.") :
        puts("\nYou failed to guess the words.")
  end

  # Pick a random word from a txt file
  def pick_random_word
    random_word = @words.sample.gsub!(/\s+/, "")
  end

  # Get words that are between 5 and 12 characters
  def proper_length_words
    proper_length = lambda { |line| line.length.between?(5, 12) }
    words = @file_contents.select(&proper_length)
  end

  # Validate input
  def is_valid_guess?(guess)
    if guess.length > 1
      puts "\nOnly enter one character"
    elsif (@incorrect_guesses.include? guess) || (@incomplete_word.include? guess)
      puts "\nYou have already entered that word"
    else
      true
    end
  end
end

hang_man = HangMan.new
hang_man.play

