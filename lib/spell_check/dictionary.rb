class Dictionary

  # Instantiates dictionary with words from the words.txt file.  This gem has been built specifically for this word
  # list, so the file name is hard coded.
  def initialize
    @words_set = Set.new
    words_file = File.expand_path(File.dirname(__FILE__) + '/words.txt')
    File.readlines(words_file).each do |line|
      @words_set.add(line.to_s.strip)
    end
  end

  # Checks if this dictionary contains the word, either in lowercase or capitalized (first character) form.  Returns
  # the matched word, or nil if no match was found.
  # @param [String] word
  # @return [String]
  def find_word( word )
    word_str = word.to_s
    found_word = nil
    if @words_set.include? word_str
      found_word = word_str
    elsif @words_set.include? word_str.capitalize
      found_word = word_str.capitalize
    elsif @words_set.include? word_str.downcase
      found_word = word_str.downcase
    end
    return found_word
  end

  def find_reg_ex_matches( reg_ex )
    match_set = Set.new
    @words_set.to_a.each do |word|
      match_set.add word if word.downcase.match(reg_ex)
    end
    return match_set
  end

end