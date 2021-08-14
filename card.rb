# frozen_string_literal: true

class Card
  attr_reader :type, :suit
  attr_accessor :point

  def initialize(suit, rank, point)
    @type = rank
    @suit = suit
    @point = point
  end
end
