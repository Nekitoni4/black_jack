# frozen_string_literal: true

require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'bank'
require_relative 'text_interface'

class Game
  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @bank = Bank.new
    @deck = Deck.new
    @interface = TextInterface.new(Player.new, Dealer.new, Bank.new, Deck.new)
    @player_turn = true
  end

  def self.play
    new.send(:start_round)
  end

  private

  attr_reader :interface, :dealer, :player, :deck
  attr_accessor :player_turn


  def start_round
    interface.start_round
    interface.card_distribution
    interface.round_bet
    loop do
      if player_turn
        interface.player_status
        interface.player_turn
      else
        interface.dealer_hidden_status
        dealer_turn
      end
      switch_turn
    end
  end

  def dealer_turn
    if dealer.hand.total < 17
      dealer.hand.take_card deck.issuing_card
      interface.add_card_view dealer
    else
      interface.skip_turn_view dealer
    end
  end

  def switch_turn
    player_turn ? (self.player_turn = false) : (self.player_turn = true)
  end
end
