# frozen_string_literal: true

require_relative 'hand'

class BlackJackPlayer
  attr_accessor :name
  attr_reader :hand

  def initialize
    @money = nil
    @hand = Hand.new
    @name = nil
  end

  def pay(tax)
    pay_for_round tax if enough_money? tax
  end

  def take_win(money)
    self.money += money
  end

  private

  attr_accessor :money

  def enough_money?(tax)
    (money - tax).negative?
  end

  def pay_for_round(tax)
    self.money -= tax
  end
end
