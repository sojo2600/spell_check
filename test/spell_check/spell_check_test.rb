require 'test/unit'
require 'spell_check'

class SpellCheckTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_check_word_with_real_and_fake_words
    real = 'real'
    fake = 'asillitheil'
    assert_match(SpellCheck.checkWord(real), real)
    assert_match(SpellCheck.checkWord(fake), 'no correction found')
  end

  def test_check_word_with_numbers
    assert_match(SpellCheck.checkWord(12345), 'no correction found')
    assert_match(SpellCheck.checkWord(12345.12345), 'no correction found')
  end

  def test_check_word_with_special_characters
    assert_match(SpellCheck.checkWord('@#$ ^%*&/'), 'no correction found')
  end

  def test_check_word_with_mixed_case
    word = 'CaRrOT'
    assert_match(SpellCheck.checkWord(word), 'carrot')
  end

  def test_word_with_repeated_chars
    word = 'pphhoonnee'
    assert_match(SpellCheck.checkWord(word), 'phone')
  end

  def test_similar_words
    assert_match(SpellCheck.checkWord('ggodd'), 'god')
    assert_match(SpellCheck.checkWord('ggoodd'), 'good')
  end

  def test_capitalized
    assert_match(SpellCheck.checkWord('Godd'), 'God')
  end

end