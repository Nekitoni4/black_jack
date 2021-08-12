class CommonPlayer

  attr_accessor :name

  def initialize
    @cards_sleeve = []
    @total = nil
    @name = nil
    @points = nil
  end

  def add_card(*cards)
    cards.each { |card| push_card card }
    calculate_points(*cards)
  end

  def bid(money)
    (total - money) if total >= money
  end

  def count_cards
    cards_sleeve.size
  end

  def get_win(money)
    self.total += money
  end

  protected

  attr_accessor :cards_sleeve, :total, :points

  def push_card(card)
    cards_sleeve << (ace?(card) ? ace_points(card) : card)
  end

  def calculate_points(*cards)
    cards.each { |card| self.points += card[:point] }
  end

  def ace?(card)
    card[:suit][0].eql? 'Т'
  end

  def ace_points(card)
    points + 11 > 21 ? (point = 1) : (point = 11)
    { suit: card[:suit], point: point }
  end

  def show_points
    cards_sleeve.reduce(0) { |accum, card| accum + card[:point] }
  end

  def show_sleeve
    cards_sleeve.map { |card| card[:suit] }.join(' ')
  end
end
