# frozen_string_literal: true

class Hand

  attr_reader :sleeve, :total

  def initialize
    @sleeve = []
    @total = 0
  end

  def take_card(card)
    if sleeve.size < 3
      calculate card
      sleeve << card
    end
  end

  private

  attr_writer :sleeve
  attr_writer :total

  def calculate(card)
    card_value = ace?(card) ? ace_treatment(card) : card.point
    self.total += card_value
  end

  def ace_treatment(card)
    card.point =  total + card.point > 21 ? 1 : card.point
  end

  def ace?(card)
    card.type.eql? 'Т'
  end
end
