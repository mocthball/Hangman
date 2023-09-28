# load dictionary and select word
module Dictionary
  def random_word()
    return unless File.exist? './dictionary.txt'

    file = File.open('./dictionary.txt')
    dict = file.readlines.map(&:chomp)
    file.close
    dict = dict.sample(1)
    dict[0]
  end
end
