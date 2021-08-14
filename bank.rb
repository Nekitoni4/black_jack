# frozen_string_literal: true

class Bank

  attr_reader :tax

  def initialize
    @total = 0
    @tax = 20
  end

  def put_bet
    self.total += tax
  end

  def clear_bank
    self.total = 0
  end

  def take_win
    total
  end

  def return_bet
    self.total -= tax
    tax
  end

  private

  attr_accessor :total
end
