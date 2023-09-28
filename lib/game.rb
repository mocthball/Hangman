#game schematics - ability to save game fundamental
require_relative './dictionary.rb'
require 'json'

class Hangman
  include Dictionary

  def initialize(word: self.random_word, game_disp: nil, guess_array: [], count: 0)
    @word = word
    @game_disp = game_disp || '_' * word.size
    @guess_array = guess_array
    @count = count
  end

  def main_game
    guess until game_over
    clear_screen
    puts "The WORD was: #{@word}"
    if @word == @game_disp
      puts 'You Win!' 
    else
      puts 'You Lose!'
    end
  end

  def game_display
    puts @game_disp + "\n"
    puts "Guess attempts[#{10 - @count}]: #{@guess_array}"
  end

  def guess()
    clear_screen
    game_display
    insert_guess(guess_display)
    @count += 1
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

  def game_over
    !@game_disp.include?('_') || @count > 10
  end

  def insert_guess(char)
    if char == ':'
      game_manager
    else
      @word.each_char.with_index { |c, index| @game_disp[index] = char if c == char }
      @guess_array << char unless @word.include?(char)
    end
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def game_manager
    clear_screen
    puts 'push 1 to SAVE a Game.. push 2 to LOAD a Game'
    choice = gets.chomp[0]
    until ['1', '2'].include?(choice)
      if choice == 1
        save_json
      elsif choice == 2
        load_json
      else
        'Invalid try Again'
      end
    end
  end
  
  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'word' => @word,
      'game_disp' => @game_disp,
      'guess_array' => @guess_array,
      'count' => @count
    }.to_json(*args)
  end

  def save_json
    save_json = File.open('save.json', 'w')
    save_json.write(self.to_json)
    save_json.close
    puts 'Game Saved'
    puts 'Push any key to continue ...'
    gets.chomp
  end

  def load_json
    open_json = File.open('save.json', 'r') # Open the file in read mode
    puts "HERE"
    object = JSON.parse(open_json.read)
    open_json.close
    loaded_game(object)
  end

  def loaded_game(obj)
    puts obj
    @word = obj['word']
    @game_disp = obj['game_disp']
    @guess_array = obj['guess_array']
    @count = obj['count']
  end
end

game = Hangman.new
obj = game.main_game
#load_game = Hangman.new(word: obj['word'], game_disp: obj['game_disp'], guess_array: obj['guess_array'], count: obj['count'])
#load_game.main_game