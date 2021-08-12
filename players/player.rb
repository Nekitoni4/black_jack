require_relative '../players/common_player'

class Player < CommonPlayer
  def initialize
    super
    @total = 100
  end
end