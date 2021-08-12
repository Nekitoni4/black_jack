require_relative '../players/common_player'

class Dealer < CommonPlayer
  def initialize
    super
    @total_money = 100
    @points = 0
    @name = "Дилер"
  end

  def hidden_sleeve
    @cards_sleeve.map { |card| '*' }.join
  end
end