class Mastermind
  attr_reader :user_guesses, :secret_code

  ATTEMPT_LIMIT = 10
  COLORS = %i[red blue green yellow magenta cyan]
  SECRET_CODE_SLOTS = 4

  def initialize
    @user_guesses = []
    @secret_code = generate_secret_code
    @feedback = []
  end

  def generate_secret_code
    @secret_code = SECRET_CODE_SLOTS.times.map { |_i| COLORS.sample }
  end

  def add_user_guess(user_guess)
    @user_guesses << user_guess
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

  def run_guess_mode
    # Cycle until attempt limit is reached
    ATTEMPT_LIMIT.times do
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
      # Save user guess
      add_user_guess(user_guess)

      # Give feedback
      puts 'Your guess is:'
      puts user_guesses.last.map { |color| color.to_s.colorize(color) }.join(' ')
      puts 'These are your hints:'
      puts play.map { |color| color.to_s.colorize(color) }.join(' ')

      # If guess is correct, end loop
      break if play.count { |item| item == :red } == SECRET_CODE_SLOTS
    end

    # Give win/lose message
    if play.count { |item| item == :red } == SECRET_CODE_SLOTS
      puts "You won!\n\n"
    else
      puts "You lost!\n\n"
    end

    # Show last guess and secret code
    puts 'Your last guess was:'
    puts user_guesses.last.map { |color| color.to_s.colorize(color) }.join(' ')

    puts 'The secret code is:'
    puts secret_code.map { |color| color.to_s.colorize(color) }.join(' ')
  end
end
