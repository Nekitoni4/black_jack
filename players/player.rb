require_relative '../players/common_player'

class Player < CommonPlayer
  def initialize
    super
    @total = 100
    @points = 0
  end
end