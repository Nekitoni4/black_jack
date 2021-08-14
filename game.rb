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
    @interface = TextInterface.new(@player, @dealer, @bank, @deck)
    @player_turn = true
  end

  def self.play
    new.send(:start_game)
  end

  private

  attr_reader :interface, :dealer, :player, :deck, :bank
  attr_accessor :player_turn

  def start_game
    loop do
      interface.start_round
      start_round
      break unless interface.continue?
    end
    interface.good_buy
  end


  def start_round
    interface.card_distribution
    interface.round_bet
    loop do
      if player_turn
        interface.player_status
        break if interface.player_turn == 3
      else
        interface.dealer_hidden_status
        dealer_turn
      end
      switch_turn
      break if player.hand.count_cards == 3 || dealer.hand.count_cards == 3
    end
    deal
  end

  def dealer_turn
    if dealer.hand.total < 17
      dealer.hand.take_card deck.issuing_card
      interface.add_card_view dealer
    else
      interface.skip_turn_view dealer
    end
  end

  def deal
    interface.deal
    if calculate_winner.nil?
      take_draw
      interface.draw_view
    else
      take_winner calculate_winner
      interface.winner_view calculate_winner
    end
  end

  def calculate_winner
    dealer_points = dealer.hand.total
    player_points = player.hand.total
    dealer_points_diff = (21 - dealer_points).abs
    player_points_diff = (21 - player_points).abs
    nil if dealer_points == player_points
    dealer if (dealer_points <= 21 && player_points > 21) || (dealer_points_diff < player_points_diff)
    player if (player_points <= 21 && dealer_points > 21) || (player_points_diff < dealer_points_diff)
  end

  def take_draw
    player.take_win bank.return_bet
    dealer.take_win bank.return_bet
  end

  def take_winner(winner_player)
    winner_player.take_win bank.take_win
    bank.clear_bank
  end

  def switch_turn
    player_turn ? (self.player_turn = false) : (self.player_turn = true)
  end
end
