# module for all input throughout game

module Input
  def game_save_prompt
    puts 'push 1 to SAVE a Game.. push 2 to LOAD a Game.. x to exit'
    choice = gets.chomp[0]
    until %w[1 2 x].include?(choice)
      puts 'invalid input try again'
      choice = get.chomp[0]
    end
    choice.downcase
  end

  def guess_display
    guess = nil
    print "Insert guess: "
    guess = gets.chomp[0]
    until guess && ('a'..'z').include?(guess) || guess == ':'
      print 'Invalid guess, guess again: '
      guess = gets.chomp[0]
    end
    guess.downcase
  end
end