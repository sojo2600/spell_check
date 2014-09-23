require 'test/unit'
require 'spell_check/dictionary'

class DictionaryTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @dict = Dictionary.new()
  end

  def test_find_word_with_real_and_fake_word
    real = 'real'
    fake = 'asilitheil'
    assert @dict.find_word real
    refute @dict.find_word fake
  end

  def test_find_word_with_capitalized_word
    assert @dict.find_word 'Monkey'
  end

  def test_find_reg_ex_matches
    reg_ex = Regexp.new('^[p]+[h]+[o]+[n]+[e]+$')
    phone = Set.new ['phone'] # Set with only one match
    assert(@dict.find_reg_ex_matches(reg_ex) == phone)
  end


end