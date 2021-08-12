# frozen_string_literal: true

require_relative '../modules/card_module'

class BlackJackInterface
  include CardModule

  def initialize
    @session_bank = 0
    @player = Player.new
    @dealer = Dealer.new
    @cards = fill_cards
    @player_turn = true
  end

  def self.start
    new.send(:game_view)
  end

  private

  TAX = 10

  attr_accessor :session_bank, :player, :dealer, :cards, :player_turn

  def game_view
    puts 'Здравствуйте! Вы в игре блэк-джек! Для начала игровой сессии введите имя'
    player.name = gets.chomp
    puts "Добро пожаловать #{player.name}!"
    loop do
      game_session
      break unless continue_game?

      clear_session
    end
    puts 'Спасибо за игру, до свидания!'
  end

  def game_session
    init_cards_distribution
    puts 'Карты розданы!'
    puts "Ставки сделаны и внесены в банк игры - ставок больше нет\n____________________________\n\n"
    puts "Игрок #{player.name}\n" \
        "________\nКарты: #{player.send(:show_sleeve)}.\nКоличество очков: #{player.send(:show_points)}\n_______\n"
    session_repl
    ending
  end

  def session_repl
    loop do
      if player_turn
        puts "#{player.name}, сейчас ваш ход!\nВы можете сделать следующее:\n1)Пропустить ход\n" \
        "2)Добавить карту (до 3 карт включительно!)\n3)Открыть карты"
        action = gets.to_i
        action == 3 ? break : player_game(action)
      else
        dealer_game
      end
      change_turn
      break if (dealer.count_cards == 3) || (player.count_cards == 3)
    end
  end

  def player_game(action)
    puts "Дилер\n________\nКарты: #{dealer.hidden_sleeve}\n________\n"
    case action
    when 1 then puts 'Ход пропущен!'
    when 2
      player.add_card cards_issuance
      puts 'Вы добавили карту'
    when 3 then puts 'Вы пропустили ход'
    else puts 'Некорректное значение/вы превысили лимит добавления карт'
    end
  end

  def dealer_game
    if (0..16).include? dealer.send(:show_points)
      puts "Дилер берёт карту!\n_____"
      dealer.add_card cards_issuance
    else
      puts "Дилер пропускает ход!\n_____"
    end
  end

  def change_turn
    player_turn ? (self.player_turn = false) : (self.player_turn = true)
  end

  def ending
    puts "Карты вскрыты! У дилера следующие карты: #{dealer.send(:show_sleeve)}." \
    "Количество очков: #{dealer.send(:show_points)}.\n" \
    "У игрока #{player.name} следующие карты: #{player.send(:show_sleeve)} " \
    "Количество очков: #{player.send(:show_points)}"
    winner = calculate_winner
    winner.nil? ? puts('К сожалению - ничья!(') : puts("Победитель: #{winner.name}!!")
    bank_control winner
  end

  def calculate_winner
    dealer_points = dealer.send(:show_points)
    player_points = player.send(:show_points)
    dealer_points_diff = (21 - dealer_points).abs
    player_points_diff = (21 - player_points).abs
    nil if dealer_points == player_points
    dealer if (dealer_points <= 21 && player_points > 21) || (dealer_points_diff < player_points_diff)
    player if (player_points <= 21 && dealer_points > 21) || (player_points_diff < dealer_points_diff)
  end

  def bank_control(winner)
    winner.nil? ? draw(TAX) : win(winner)
  end

  def win(winner)
    self.session_bank = 0
    winner.get_win session_bank
  end

  def continue_game?
    puts "#{player.name}, хотите продолжить игру?\n1)Да\n2)Нет"
    loop do
      case gets.to_i
      when 1 then return true
      when 2 then return false
      else puts 'Некорректное значение, пожалуйста, введите заново'
      end
    end
  end

  def draw(money)
    self.session_bank -= money
    player.get_win money
    dealer.get_win money
  end

  def session_bid
    player_payment = player.bid(TAX)
    dealer_payment = dealer.bid(TAX)
    if dealer_payment || dealer_payment
      top_up_game_bank(player_payment, dealer_payment)
    else
      raise('У одного из игроков нет средств на новую партию!')
    end
  end

  def top_up_game_bank(*payments)
    payments.each { |payment| self.session_bank += payment }
  end

  def clear_session
    player.clear_sleeve
    dealer.clear_sleeve
  end

  def init_cards_distribution
    player.add_card cards_issuance, cards_issuance
    dealer.add_card cards_issuance, cards_issuance
  end
end
