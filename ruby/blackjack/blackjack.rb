class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end
end

class Game
  attr_accessor :points_dealer, :points_player, :cards_player, :visible_card_dealer, :hidden_card_dealer
  BLACKJACK = 21
  HOUSECAP = 17
  
  def initialize
    @points_dealer = 0
    @points_player = 0
    @cards_player = []
    @hidden_card_dealer = nil
    @cards_dealer = []
  end
  
  def game_start
    @deck = Deck.new
    @deck.shuffle
    2.times do 
      @points_player = @points_player + deal_in_game(@cards_player, @deck, @points_player, "Player")
    end
     point_check(@points_player, "Player")
     2.times do 
      @points_dealer = @points_dealer + deal_in_game(@cards_dealer, @deck, @points_dealer, "House")
    end
    point_check(@points_dealer, "House")
    @hidden_card_dealer = @cards_dealer[0]
    until @points_dealer >= HOUSECAP do
      @points_dealer = @points_dealer + deal_in_game(@cards_dealer, @deck, @points_dealer, "House")
      point_check(@points_dealer, "House")
    end 
    game_in_progress
  end
  
  def game_in_progress
    if @points_player < BLACKJACK
      @points_player = @points_player + deal_in_game(@cards_player, @deck, @points_player, "Player")
      point_check(@points_player, "Player")
    end
    game_in_progress
  end
  
  

  def deal_in_game(hand, deck, points_current, person)
    @deck = deck
    card = @deck.deal_card
    hand.push(card)
    puts "Dealt #{card.name} of #{card.suite} to #{person}"
    puts "\n"
    
    if card.name.to_s == 'ace' && 11 + points_current > BLACKJACK
        point = 1
    elsif card.name.to_s == 'ace' && 11 + points_current <= BLACKJACK
        point = 11
    elsif card.name.to_s != 'ace'
        point = hand[-1].value
    end
    return point
  end
  
  def point_check(points, person)
    game_end = false
    if points == BLACKJACK
      puts "#{person} Wins!"
       game_end = true
      exit(0)
    elsif points > BLACKJACK
      puts "#{person} Busts"
       game_end = true
      exit(0)
    end
    return game_end
  end
  
  
end
