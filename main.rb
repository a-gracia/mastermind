require 'colorize'
require_relative 'lib/mastermind'

# # Ask user who is going to play
# player = 0

# until player == 1 || player == 2
#   puts "Choose your game mode"
#   puts "1. Guess mode"
#   puts "2. Secret code creator mode"
#   player = gets.chomp.to_i
# end

# puts player == 1 ? "\n\n*** Guess mode ***\n\n" : "*** Secret code creator mode ***\n\n"

# Create random secret code
game = Mastermind.new

game.run_guess_mode
