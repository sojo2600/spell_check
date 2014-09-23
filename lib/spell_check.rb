require 'spell_check/version'
require 'spell_check/dictionary'

module SpellCheck

  # Checks if input word exists in dictionary.  This method will accept any case and will make corrections for any
  # over-repeated strings.
  # @param [Object] aWordToCheck
  # @return [String]
  def self.checkWord( aWordToCheck )
    @dict = Dictionary.new
    not_found = 'no correction found'

    # Check for any non-alphabet characters.  If any are found, cease word search
    return not_found if has_non_alphabet_chars aWordToCheck

    # Adjust word for case
    word = adjust_case( aWordToCheck )

    # Attempt to see if input word is found before doing regular expression search
    corrected_word = @dict.find_word word
    return corrected_word unless corrected_word.nil?

    # Input word was not found, so try matching regular expression
    corrected_word = correct_repetitions word
    return corrected_word unless corrected_word.nil?

    return not_found
  end

private

  # Returns true if any non-English alphabet characters exist in input object, false otherwise. This is also the
  # primary check to ensure that the object will convert to a String
  # @param [Object] word
  # @return [Boolean]
  def self.has_non_alphabet_chars( word )
    return word.to_s.match(/[^A-Za-z]/) rescue true
  end

  # Takes an input object, converts it to a string, then returns it with all but the first character down cased.  The
  # first character case is retained for comparing between words like god and God
  # @param [String] word
  # @return [String]
  def self.adjust_case( word )
    return word[0] + word[1..word.length].to_s.downcase if word.length > 1
    word # string contains one or fewer characters
  end

  # This is the main logic block for correcting repetition spelling errors.  This method removes all consecutive
  # repetition of characters in a word, builds a regular expression that allows repetitions of each character,
  # scans the dictionary for any matches to this regular expression, then finds and returns the closest match.
  # @param [String] word
  # @return [String]
  def self.correct_repetitions( word )
    # Remove all consecutive repetitions of characters in the word
    squeeze_str = word.downcase.squeeze

    # Create a set of potential matches using regular expression
    reg_ex_matches = find_reg_ex_matches squeeze_str

    # Compare matches against original input and return closest match
    return get_best_match word, reg_ex_matches unless reg_ex_matches.empty?

    nil # no corrections found
  end

  # Builds a RegExp object and then matches it against the dictionary values
  # @param [String] word
  # @return [Set]
  def self.find_reg_ex_matches( word )
    reg_ex = build_reg_ex word
    @dict.find_reg_ex_matches reg_ex
  end

  # Creates a regular expression object that allows any number of consecutive repetitions of each character in the
  # input string.
  # @param [String] word
  # @return [RegExp]
  def self.build_reg_ex( word )
    exp_str = '^' # disallow preceding characters
    word.chars.each do |char|
      exp_str += '[' + char + ']' + '+' # this allows 1 or more instances of this char
    end
    exp_str += '$' # disallow trailing characters
    Regexp.new exp_str
  end

  # Given a set of words that are possible corrections for the input word, this method compares the corrected words
  # to the input and returns to closest matching correction using Levenshtein distance.
  # @param [String] word
  # @param [Set] matches
  # @return [Array]
  def self.get_best_match( word, matches )
    lev_array = matches.to_a
    lev_array.sort! { |x,y| levenshtein_distance(x,word) <=> levenshtein_distance(y,word)}
    lev_array.first # lowest number of changes means closest match to original input
  end

  # The Levenshtein Distance algorithm measures the number of changes required to match two strings.  For this reason
  # it is a good method to compare the similarity of strings.  Please note that this code was sourced at
  # http://stackoverflow.com/questions/16323571/measure-the-distance-between-two-strings-with-ruby
  # @param [String] s
  # @param [String] t
  # @return [Integer]
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