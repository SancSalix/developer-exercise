require 'test/unit'
require 'pry'
require_relative 'blackjack'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert(@deck.playable_cards.include?(card) == false)
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

class GameTest < Test::Unit::TestCase
  def setup
    @game = Game.new
    @deck = Deck.new
  end

  def test_points_for_bust
    points_test = 23
    assert_equal @game.point_check(points_test, "Player"), true
  end
  
  def test_points_for_blackjack
    points_test = 21
    assert_equal @game.point_check(points_test, "House"), true
  end

  def test_no_end
    points_test = 18
    assert_equal @game.point_check(points_test, "House"), false
  end
  
  def test_return_point
    @deck.shuffle
    @cards_player = []
    @points_player = @game.deal_in_game(@cards_player, @deck, @points_player)
    assert(@points_player > 0, "Points were not added to total")
  end
  
end