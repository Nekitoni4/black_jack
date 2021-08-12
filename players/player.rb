require_relative '../players/common_player'

class Player < CommonPlayer
  def initialize
    super
    @total_money = 100
    @points = 0
  end
end