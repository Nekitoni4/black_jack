require_relative '../players/common_player'

class Dealer < CommonPlayer
  def initialize
    super
    @total = 100
  end

  def hidden_sleeve
    @cards_sleeve.map { |card| '*' }.join
  end
end