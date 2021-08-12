module CardModule
  def fill_cards
    cards = {}
    suits = %W[\u2660 \u2665 \u2663 \u2666]
    ranks = %w[В Д К Т]
    suits.each do |suit|
      2.upto(10) do |i|
        cards["#{i}#{suit}"] = i
      end
      ranks.each do |rank|
        cards["#{rank}#{suit}"] = 10
      end
    end
    cards
  end

  def cards_issuance
    random_suit = cards.keys[Random.rand(cards.keys.size)]
    { suit: random_suit, point: cards[random_suit] }
  end
end