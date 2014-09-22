require 'test/unit'
require 'spell_check/dictionary'

class DictionaryTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @dict = Dictionary.new()
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Tests the main method of the Dictionary class, word_exists
  def test_find_word_with_real_and_fake_word
    real = 'real'
    fake = 'asilitheil'
    assert @dict.find_word real
    refute @dict.find_word fake
  end


end