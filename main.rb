require 'colorize'
require_relative 'lib/mastermind'

require 'pry-byebug'

# check_hints(%i[red red blue blue], %i[red blue red green])
# rww
# p Mastermind.check_hints(%i[red blue red green], %i[blue red blue red])
# www

game = Mastermind.new

game.run_guess_mode
