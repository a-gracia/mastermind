class Mastermind
  attr_reader :user_guesses, :secret_code

  ATTEMPT_LIMIT = 10
  COLORS = [:red,:blue,:green,:yellow,:magenta,:cyan]
  SECRET_CODE_SLOTS = 4

  def initialize
    @user_guesses = []
    @secret_code = generate_secret_code
    @feedback = []
  end

  def generate_secret_code
    @secret_code = SECRET_CODE_SLOTS.times.map {|i| COLORS.shuffle.first}
  end

  def add_user_guess(user_guess)
    @user_guesses.push user_guess
  end

  def play
    temp_secret_code = []
    guess = []
    
    # If there is a match in the guess, store a red hint
    # and delete the element in both arrays
    hints = []
    @secret_code.each_with_index do |secret_color, i| 
      if secret_color == @user_guesses.last[i]
        hints.push :red
      else
        temp_secret_code.push secret_color
        guess.push @user_guesses.last[i]
      end
    end
    
    # Then check if the remaining guesses are included in
    # the secret code
    temp_secret_code.each_with_index {|secret_color, i| hints.push :white if guess.include? secret_color }

    # return shuffled hints
    hints.shuffle
  end
end