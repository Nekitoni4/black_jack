# frozen_string_literal: true

class TextInterface
  def initialize(player, dealer, bank, deck)
    @player = player
    @dealer = dealer
    @bank = bank
    @deck = deck
  end

  def start_round
    puts 'Приветствую вас в игре Блэк Джек! Для того, чтобы продолжить игру - введите ваше имя'
    player.name = gets.chomp
    puts "Здравствуйте, #{player.name}"
  end

  def card_distribution
    player.hand.take_card(deck.issuing_card)
    dealer.hand.take_card(deck.issuing_card)
    puts 'Карты розданы!'
  end

  def round_bet
    player.pay(bank.tax)
    dealer.pay(bank.tax)
    puts 'Ставки сделаны - ставок больше нет!'
  end

  def player_status
    puts "У #{player.name} следующие карты: #{render_cards player}\nКоличество очков: #{player.hand.total}"
  end

  def dealer_hidden_status
    puts "У #{dealer.name} следующие карты: #{render_hidden_cards}"
  end


  def dealer_status
    puts "У #{dealer.name} следующие карты: #{render_cards dealer}\nКоличество очков: #{dealer.hand.total}"
  end

  def player_turn
    puts "#{player.name} - ваш ход!\nВыберите порядковый номер того, что вы хотите сделать:\n1)Пропустить ход\n" \
    "2)Взять карту(до 3 включительно)\n3)Сдать карты"
    loop do
      case gets.to_i
      when 1
        skip_turn_view player
        break
      when 2
        player.hand.take_card deck.issuing_card
        add_card_view player
        break
      when 3
        return 3
      else puts 'Некорректное значение, пожалуйста, попробуйте ещё раз'
      end
    end
  end

  def skip_turn_view(player)
    puts "#{player.name} пропускает ход"
  end

  def add_card_view(player)
    puts "#{player.name} берёт карту"
  end

  def deal
    puts "Карты сданы!\n"
    player_status
    dealer_status
  end

  def winner_view(winner_player)
    puts "Победил #{winner_player.name}"
  end

  def draw_view
    puts 'К сожалению ничья!'
  end

  def continue?
    puts "#{player.name} - хотите продолжить?"
    loop do
      case gets.chomp.downcase
      when 'да' then return true
      when 'нет' then return false
      else puts 'Некорректное значение'
      end
    end
  end
  
  def good_buy
    puts "Спасибо за игру, #{player.name}"
  end

  private

  attr_reader :player, :dealer, :bank, :deck

  def render_cards(player)
    player.hand.sleeve.map { |card| "#{card.type}#{card.suit}" }.join
  end

  def render_hidden_cards
    dealer.hand.sleeve.map {'*'}.join
  end
end
