require 'test/unit'
require 'spell_check'

class SpellCheckTest < Test::Unit::TestCase

  def test_real_and_fake_words
    real = 'real'
    fake = 'asillitheil'
    assert_match(SpellCheck.checkWord(real), real)
    assert_match(SpellCheck.checkWord(fake), 'no correction found')
  end

  def test_numbers
    assert_match(SpellCheck.checkWord(12345), 'no correction found')
    assert_match(SpellCheck.checkWord(12345.12345), 'no correction found')
  end

  def test_special_characters
    assert_match(SpellCheck.checkWord('@#$ ^%*&/'), 'no correction found')
  end

  def test_mixed_case
    word = 'CaRrOT'
    assert_match(SpellCheck.checkWord(word), 'carrot')
  end

  def test_word_with_repeated_chars
    word = 'pphhoonnee'
    assert_match(SpellCheck.checkWord(word), 'phone')
  end

  def test_similar_words
    assert_match(SpellCheck.checkWord('Godd'), 'God')
    assert_match(SpellCheck.checkWord('goodd'), 'good')
  end

  def test_capitalized
    assert_match(SpellCheck.checkWord('ZZabiann'), 'Zabian')
  end

  def test_under_repeated_chars
    assert_match(SpellCheck.checkWord('excelent'), 'excellent')
  end

  def test_levenshtein_distance
    assert(SpellCheck.levenshtein_distance('cat', 'catt') == 1)
    assert(SpellCheck.levenshtein_distance('dog', 'Dog') == 1)
    assert(SpellCheck.levenshtein_distance('fish', 'fish') == 0)
    assert(SpellCheck.levenshtein_distance('dog', 'cat') == 3)
  end

  def test_get_best_match
    matches = %w{shoot shot window key car sky bug}
    assert_match(SpellCheck.get_best_match('shoott', matches), 'shoot')
  end

  def test_build_reg_ex
    reg_ex = Regexp.new('^[p]+[h]+[o]+[n]+[e]+$')
    assert_match(SpellCheck.build_reg_ex('phone').inspect, reg_ex.inspect)
  end

  def test_find_reg_ex_matches
    phone = Set.new ['phone'] # Set with only one match
    matches = SpellCheck.find_reg_ex_matches('phone')
    assert(matches == phone)
  end

  def test_adjust_case
    assert_match(SpellCheck.adjust_case('CaRrOT'), 'Carrot')
    assert_match(SpellCheck.adjust_case('cARROT'), 'carrot')
    assert_match(SpellCheck.adjust_case('z'), 'z')
    assert_match(SpellCheck.adjust_case(''), '')
  end

end