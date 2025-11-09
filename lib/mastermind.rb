require 'pry-byebug'

class Mastermind
  attr_reader :user_guesses, :secret_code

  ATTEMPT_LIMIT = 10
  COLORS = %i[red blue green yellow magenta cyan]
  SECRET_CODE_SLOTS = 4

  def initialize
    # Ask user who is going to play
    player = 0

    until [1, 2].include?(player)
      puts "Choose your game mode\n1. Guess mode\n2. Secret code creator mode"
      player = gets.chomp.to_i
    end

    if player == 1
      puts "\n\n*** Guess mode ***\n\n"
      @secret_code = SECRET_CODE_SLOTS.times.map { |_i| COLORS.sample }
      @player = :user
    else
      puts "*** Secret code creator mode ***\n\n"
      @secret_code = ask_user_guess
      @player = :cpu

      @possible_codes = []
      COLORS.repeated_permutation(4) { |permutation| @possible_codes << permutation }
      @reduced_list = @possible_codes
    end

    @current_hint = []
    @attempt = 0
  end

  def ask_cpu_guess
    if @attempt == 1
      %i[red red blue blue]
    else
      @reduced_list = @reduced_list.select { |code| check_hints(@guess, code) == @current_hint }

      return @reduced_list.first if @reduced_list.length == 1

      code_hint_count = {}

      @possible_codes.each do |code|
        code_hint_count[code.join('.')] = @reduced_list.each_with_object(Hash.new(0)) do |reduced_code, result|
          result[check_hints(code, reduced_code).join] += 1
          result
        end
      end

      code_hint_count2 = {}

      code_hint_count.each do |key, val|
        mapped_val = val.map { |k, v| v }
        code_hint_count2[key] = mapped_val.sum - mapped_val.max
      end

      # Return value with max score
      code_hint_count2.max_by { |key, value| value }[0].split('.').map { |color| color.to_sym }
    end
  end

  def check_hints(secret_code, user_guess)
    temp_secret_code = []
    guess = []

    # If there is a match in the guess, store a red hint
    # and delete the element in both arrays
    hints = []
    secret_code.each_with_index do |secret_color, i|
      if secret_color == user_guess[i]
        hints << :red
      else
        temp_secret_code << secret_color
        guess << user_guess[i]
      end
    end

    # Then check if the remaining guesses are included in
    # the secret code

    temp_secret_code.each do |secret_color|
      next unless guess.include? secret_color

      hints << :white
      guess.delete_at(guess.index(secret_color))
    end

    # return shuffled hints
    hints
  end

  def ask_user_guess
    # Ask user guess until slots are filled
    user_guess = []
    until user_guess.length == SECRET_CODE_SLOTS
      puts "You have chosen #{user_guess.length} out of #{SECRET_CODE_SLOTS}.\n\n"

      unless user_guess.empty?
        puts 'Your current guess is:'
        puts user_guess.map { |color| color.to_s.colorize(color) }.join(' ')
        puts "\n"
      end

      puts 'Choose one of the following colors:'
      puts COLORS.map { |color| color.to_s.colorize(color) }.join(' ')
      puts "\n>"
      user_choice = gets.chomp.to_sym

      # check if color list includes user choice
      user_guess << user_choice if COLORS.include? user_choice
    end
    user_guess
  end

  def give_feedback
    puts 'Your guess is:'
    puts @guess.map { |color| color.to_s.colorize(color) }.join(' ')
    puts 'These are your hints:'
    puts @current_hint.shuffle.map { |color| color.to_s.colorize(color) }.join(' ')
  end

  def give_results
    # Give win/lose message
    puts @current_hint.count(:red) == SECRET_CODE_SLOTS ? "You won!\n\n" : "You lost!\n\n"

    # Show last guess and secret code
    puts 'Your last guess was:'
    puts @guess.map { |color| color.to_s.colorize(color) }.join(' ')

    puts 'The secret code is:'
    puts secret_code.map { |color| color.to_s.colorize(color) }.join(' ')
  end

  def run_guess_mode
    # Cycle until attempt limit is reached
    ATTEMPT_LIMIT.times do
      @attempt += 1
      # Ask user guess
      @guess = @player == :user ? ask_user_guess : ask_cpu_guess
      # Check hints
      @current_hint = check_hints(@secret_code, @guess)
      # Give feedback
      give_feedback
      # If guess is correct, end loop
      break if @current_hint.count(:red) == SECRET_CODE_SLOTS
    end
    # Give results
    give_results
  end
end
