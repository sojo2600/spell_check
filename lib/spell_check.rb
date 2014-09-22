require 'spell_check/version'
require 'spell_check/dictionary'

module SpellCheck

  # Checks if input word exists in dictionary.  This method will accept any case and will make corrections for any
  # over-repeated strings.
  # @param [Object] word
  # @return [String]
  def self.checkWord( aWordToCheck )
    @dict = Dictionary.new
    not_found = 'no correction found'

    # Check for any non-alphabet characters.  If any are found, cease word search
    return not_found if has_non_alphabet_chars aWordToCheck

    # Adjust word for case
    word = adjust_case( aWordToCheck )

    # Attempt to see if input word is found before doing regular expression search
    corrected_word = @dict.find_word(word)
    return corrected_word unless corrected_word.nil?

    # Input word was not found, so try matching regular expression
    corrected_word = correct_repetitions(word)
    return corrected_word unless corrected_word.nil?

    return not_found
  end

private

  # Returns true if any non-English alphabet characters exist in input object, false otherwise.
  # @param [Object] word
  # @return [Boolean]
  def self.has_non_alphabet_chars ( word )
    begin
      word.to_s.match(/[^A-Za-z]/)
    rescue
      puts 'Invalid input: Please enter only characters from the English alphabet.'
    end
  end

  # Takes an input object, converts it to a string, then returns it with all but the first character down cased.  The
  # first character case is retained for comparing between words like god and God
  # @param [String] word
  # @return [String]
  def self.adjust_case( word )
    if word.length > 1
      return word[0] + word[1..word.length].to_s.downcase
    else
      return word
    end
  end

  # This is the main logic block for correcting repetition spelling errors.  This method
  # @param [String] word
  # @return [String]
  def self.correct_repetitions( word )
    downcase_word = word.downcase
    chars = downcase_word.chars
    dup_hash = find_consecutive_duplicates chars
    return nil if dup_hash.nil?

    # Create an array of sub-strings with non-repeating characters, divided where repetitions occur
    str_array = build_sub_string_array downcase_word, dup_hash

    # Create a set of potential matches using regular expressions
    reg_ex_matches = get_reg_ex_matches str_array

    # Compare matches against original input and return closest match
    return get_best_match word, reg_ex_matches unless reg_ex_matches.empty?

    return nil
  end

  # Seeks out consecutive duplicates of characters, stores their characters and repetition counts.  The index of the
  # first duplicate char is the key and the value is the repetition count after the first.  For example, string
  # 'ccc' would have a key of 0 and a value of 2.
  # @param [Array] chars
  # @return [Hash]
  def self.find_consecutive_duplicates( chars )
    dup_hash = Hash.new
    prev_char = nil
    cur_index = nil
    chars.each_with_index do |char, index|
      if char == prev_char
        if cur_index.nil?
          cur_index = index
          dup_hash[cur_index] = 0
        end
        dup_hash[cur_index] += 1
      else
        cur_index = nil
      end
      prev_char = char
    end
    return dup_hash
  end

  # Creates an array of sub strings that exist between repeated characters in the word parameter
  def self.build_sub_string_array( word, dup_hash )
    str_array = Array.new
    keys = dup_hash.keys.sort
    cur_index = 0
    keys.each do |key|
      str_array.push(word[cur_index..key-1])
      cur_index = key + dup_hash[key]
    end
    str_array.push(word[cur_index..word.length]) unless cur_index >= word.length
    return str_array
  end

  def self.get_reg_ex_matches( str_array )
    reg_ex = build_reg_ex str_array
    @dict.find_reg_ex_matches reg_ex
  end

  # Creates a regular expression object that allows any number of multiples of the last character in each array index.
  # This satisfies the use case of over-repeated characters, but does not check for under-repeated characters.  This
  # functionality could be easily added by allowing multiples of every character in the word.
  # @param [Array] str_array
  # @return [RegExp]
  def self.build_reg_ex( str_array )
    exp_str = '^'
    str_array.each do |sub|
      reg_sub = sub[0,sub.length-1] + '[' + sub[-1,1] + ']' + '+'
      exp_str += reg_sub
    end
    exp_str += '$'
    Regexp.new exp_str
  end

  # Given a set of words that are possible corrections for the input word, this method compares the corrected words
  # to the input and returns to closest matching correction.
  # @param [String] word
  # @param [Array] matches
  def self.get_best_match( word, matches )
    lex_array = matches.to_a
    lex_array.sort! { |x,y| levenshtein_distance(x,word) <=> levenshtein_distance(y,word)}
    lex_array.first
  end

  # The Levenshtein Distance algorithm measures the number of changes required to match two strings.  For this reason
  # it is a good method to compare the similarity of strings.  Please note that this code was sourced at
  # http://stackoverflow.com/questions/16323571/measure-the-distance-between-two-strings-with-ruby
  # @param [String] s
  # @param [String] t
  def self.levenshtein_distance(s, t)
    m = s.length
    n = t.length
    return m if n == 0
    return n if m == 0
    d = Array.new(m+1) {Array.new(n+1)}

    (0..m).each {|i| d[i][0] = i}
    (0..n).each {|j| d[0][j] = j}
    (1..n).each do |j|
      (1..m).each do |i|
        d[i][j] = if s[i-1] == t[j-1]  # adjust index into string
                    d[i-1][j-1]       # no operation required
                  else
                    [ d[i-1][j]+1,    # deletion
                      d[i][j-1]+1,    # insertion
                      d[i-1][j-1]+1,  # substitution
                    ].min
                  end
      end
    end
    d[m][n]
  end

end