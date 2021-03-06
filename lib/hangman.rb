# Holds logic for checking guesses.
class Hangman
  attr_reader :secret_word,   :hidden_word
  attr_reader :guesses_left,  :wrong_characters
  attr_reader :game_finished, :game_result

  def initialize(dictionary)
    @secret_word      = dictionary.sample
    @hidden_word      = @secret_word.map { |char| char == " " ? char : "_" }
    @wrong_characters = ["-"]
    @guesses_left     = @secret_word.uniq.length + 1
    @game_finished    = false
    @game_result      = nil
  end

  def check(guess)
    if is_a_word?(guess)
      check_introduced(guess)
    elsif character_is_in_secret_word?(guess)
      add_characters_from(guess)
      player_wins  if secret_word_is_equal_to?(@hidden_word.join)
      player_loses if @guesses_left.zero?
    else
      add_wrong_characters_from(guess[0])
      player_loses if @guesses_left.zero?
    end
  end

  private

  def is_a_word?(guess)
    guess.length > 3
  end

  def check_introduced(guess)
    secret_word_is_equal_to?(guess) ? player_wins : player_loses
  end

  def secret_word_is_equal_to?(guess)
    @secret_word.join("").casecmp(guess).zero?
  end

  def character_is_in_secret_word?(guess)
    @secret_word.any? { |character| character.casecmp(guess).zero? }
  end

  def add_characters_from(guess)
    indexes = @secret_word.map
                          .with_index { |char, idx| idx if char.casecmp(guess).zero? }
                          .compact

    indexes.each { |index| @hidden_word[index] = guess }
  end

  def add_wrong_characters_from(guess)
    @wrong_characters = [] if wrong_characters_unmodified

    return if @wrong_characters.include?(guess)

    @wrong_characters << guess
    @guesses_left -= 1
  end

  def wrong_characters_unmodified
    @wrong_characters == ["-"]
  end

  def player_wins
    @hidden_word   = @secret_word
    @game_finished = true
    @game_result   = :player_wins
  end

  def player_loses
    @game_finished = true
    @game_result   = :player_loses
  end
end
