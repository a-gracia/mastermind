require "colorize"
require_relative "lib/mastermind"


# Create random secret code
game = Mastermind.new

# Cycle until attempt limit is reached
Mastermind::ATTEMPT_LIMIT.times do

  # Ask user guess until slots are filled
  user_guess = []
  until user_guess.length == Mastermind::SECRET_CODE_SLOTS
    puts "You have chosen #{user_guess.length} out of #{Mastermind::SECRET_CODE_SLOTS}.\n\n"

    unless user_guess.empty?
      puts "Your current guess is:"
      puts user_guess.map {|color| color.to_s.colorize(color)} .join(" ")
      puts "\n"
    end

    puts "Choose one of the following colors:"
    puts Mastermind::COLORS.map {|color| color.to_s.colorize(color)} .join(" ")
    puts "\n>"
    user_choice = gets.chomp.to_sym

    # check if color list includes user choice
    if Mastermind::COLORS.include? user_choice
      user_guess.push user_choice
    end
  end
  # Save user guess
  game.add_user_guess(user_guess)

  # Give feedback
  puts "Your guess is:"
  puts game.user_guesses.last.map {|color| color.to_s.colorize(color)} .join(" ")
  puts "These are your hints:"
  puts game.play.map {|color| color.to_s.colorize(color)} .join(" ")

  # If guess is correct, end loop
  break if game.play.count {|item| item == :red} == Mastermind::SECRET_CODE_SLOTS
end

# Give win/lose message
if game.play.count {|item| item == :red} == Mastermind::SECRET_CODE_SLOTS
  puts "You won!\n\n"
else
  puts "You lost!\n\n"
end

# Show last guess and secret code
puts "Your last guess was:"
puts game.user_guesses.last.map {|color| color.to_s.colorize(color)} .join(" ")

puts "The secret code is:"
puts game.secret_code.map {|color| color.to_s.colorize(color)} .join(" ")
