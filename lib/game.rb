#game schematics - ability to save game fundamental
require_relative './dictionary.rb'
require 'json'

class Hangman
  include Dictionary

  def initialize()
    @word = self.random_word
    @game_disp = '_' * @word.size
    @guess_array = Array.new
    @count = 0
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
    print "Insert guess: "
    guess = gets.chomp[0].downcase
    until ('a'..'z').include? guess
      print 'Invalid guess, guess again: '
      guess = gets.chomp[0].downcase
    end
    insert_guess(guess)
    @count += 1
  end

  def game_over
    !@game_disp.include?('_') || @count > 10
  end

  def insert_guess(char)
    if @word.include?(char)
      @word.each_char.with_index do |c, index|
        if c == char 
          @game_disp[index] = char
        end
      end
    else
      @guess_array << char
    end
  end

  def clear_screen
    system('clear') || system('cls')
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
    puts 'completed'
  end

  def load_json
    open_json = File.open('save.json', 'r') # Open the file in read mode
    json_string = open_json.read
    object = JSON.parse(json_string, object_class: Hangman)
    puts object
    open_json.close
    puts 'Loaded game'
  end
end

game = Hangman.new
game.load_json
