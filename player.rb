# frozen_string_literal: true

require_relative 'black_jack_player'

class Player < BlackJackPlayer
  def initialize
    super
    @money = 100
  end
end
