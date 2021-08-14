# frozen_string_literal: true

require_relative 'card'

class Deck
  def initialize
    @cards = generate_cards
  end

  def issuing_card
    cards[Random.rand(cards.size)]
  end

  private

  attr_reader :cards

  def generate_cards
    cards = []
    suits = %W[\u2660 \u2665 \u2663 \u2666]
    ranks = %w[В Д К Т]
    suits.each do |suit|
      2.upto(10) do |rank|
        cards << Card.new(suit, rank, rank)
      end
      ranks.each do |rank|
        cards << Card.new(suit, rank, 10)
      end
    end
    cards
  end
end
