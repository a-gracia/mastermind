class Mastermind
  attr_reader :user_guesses, :secret_code

  ATTEMPT_LIMIT = 10
  COLORS = %i[red blue green yellow magenta cyan]
  SECRET_CODE_SLOTS = 4

  def initialize
    # Ask user who is going to play
    player = 0

    until [1, 2].include?(player)
      puts 'Choose your game mode'
      puts '1. Guess mode'
      puts '2. Secret code creator mode'
      player = gets.chomp.to_i
    end

    if player == 1
      puts "\n\n*** Guess mode ***\n\n"
      @secret_code = ask_cpu_guess
      @player = :user
    else
      puts "*** Secret code creator mode ***\n\n"
      @secret_code = ask_user_guess
      @player = :cpu
    end

    @user_guesses = []
    @feedback = []
  end

  def ask_cpu_guess
    SECRET_CODE_SLOTS.times.map { |_i| COLORS.sample }
  end

  def play
    temp_secret_code = []
    guess = []

    # If there is a match in the guess, store a red hint
    # and delete the element in both arrays
    hints = []
    @secret_code.each_with_index do |secret_color, i|
      if secret_color == @user_guesses.last[i]
        hints << :red
      else
        temp_secret_code << secret_color
        guess << @user_guesses.last[i]
      end
    end

    # Then check if the remaining guesses are included in
    # the secret code
    temp_secret_code.each { |secret_color| hints << :white if guess.include? secret_color }

    # return shuffled hints
    hints.shuffle
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
    puts @user_guesses.last.map { |color| color.to_s.colorize(color) }.join(' ')
    puts 'These are your hints:'
    puts play.map { |color| color.to_s.colorize(color) }.join(' ')
  end

  def give_results
    # Give win/lose message
    puts play.count(:red) == SECRET_CODE_SLOTS ? "You won!\n\n" : "You lost!\n\n"

    # Show last guess and secret code
    puts 'Your last guess was:'
    puts @user_guesses.last.map { |color| color.to_s.colorize(color) }.join(' ')

    puts 'The secret code is:'
    puts secret_code.map { |color| color.to_s.colorize(color) }.join(' ')
  end

  def run_guess_mode
    # Cycle until attempt limit is reached
    ATTEMPT_LIMIT.times do
      # Ask user guess
      guess = @player == :user ? ask_user_guess : ask_cpu_guess
      @user_guesses << guess
      # Give feedback
      give_feedback
      # If guess is correct, end loop
      break if play.count(:red) == SECRET_CODE_SLOTS
    end
    # Give results
    give_results
  end
end
