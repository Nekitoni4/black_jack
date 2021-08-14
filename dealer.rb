require_relative 'black_jack_player'

class Dealer < BlackJackPlayer
  def initialize
    super
    @name = "Дилер"
    @money = 100
  end
end