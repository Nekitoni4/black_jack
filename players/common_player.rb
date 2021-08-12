class CommonPlayer

  attr_accessor :name

  def initialize
    @cards_sleeve = []
    @total = nil
    @name = nil
  end

  def add_card(*cards)
    cards.each { |card| push_card card }
  end

  def bid(money)
    (total - money) if total >= money
  end

  def sleeve
    show_sleeve
  end

  def points
    show_points
  end

  protected

  attr_accessor :cards_sleeve, :total

  def push_card(card)
    cards_sleeve << card
  end

  def show_points
    cards_sleeve.values.reduce(0, :+)
  end

  def show_sleeve
    cards_sleeve.keys.join(" ")
  end
end
