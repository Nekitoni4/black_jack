# frozen_string_literal: true

class BlackJackInterface
  def initialize
    @session_bank = 0
    @player = Player.new
    @dealer = Dealer.new
    @cards = fill_cards
    @player_turn = true
  end

  def start_session; end

  private

  TAX = 10

  attr_accessor :session_bank, :player, :dealer, :cards, :player_turn

  def game_view
    puts 'Здравствуйте! Вы в игре блэк-джек! Для начала игровой сессии введите имя'
    player_name(gets.chomp)
    puts "Доброе пожаловать #{player.name}!"
    init_cards_distribution
    session_bid
    puts player.send(:cards_sleeve)
    puts dealer.send(:cards_sleeve)
    puts "Ставки сделаны и внесены в банк игры - ставок больше нет\n____________________________\n\n"
    loop do
      if player_turn
        puts "Игрок #{player.name}\n" \
        "________\nКарты: #{player.send(:show_sleeve)}.\nКоличество очков: #{player.send(:show_points)}\n_______\n"
        puts "#{player.name}, сейчас ваш ход!\nВы можете сделать следующее:\n1)Пропустить ход\n" \
        "#{"2)Добавить карту\n" if player.count_cards < 3}3)Открыть карты"
        action = gets.to_i
        if action == 3
          final
          break
        else
          puts "Диллер\n________\nКарты: #{dealer.hidden_sleeve}\n________\n"
          player_game action
        end
      else
        dealer_game
      end
      change_turn
      if (dealer.count_cards == 3) || (player.count_cards == 3)
        final
        break
      end
    end
  end

  def player_game(action)
    case action
    when (action == 2 && player.count_cards <= 3)
      player.add_card cards_issuance
      puts 'Вы добавили карту'
    when 3 then puts 'Вы пропустили ход'
    else puts 'Некорректное значение'
    end
  end

  def dealer_game
    puts dealer.count_cards
    if (0..16).include? dealer.send(:show_points)
      puts "Диллер берёт карту!\n_____"
      dealer.add_card cards_issuance
    else
      puts "Диллер пропускает ход!\n_____"
    end
  end

  def change_turn
    player_turn ? (self.player_turn = false) : (self.player_turn = true)
  end

  def final
    show_cards
    winner = calculate_winner
    winner.nil? ? puts('К сожалению - ничья!(') : puts("Победитель: #{winner.name}!!")
    bank_control winner
  end

  def show_cards
    puts "Карты вскрыты! У диллера следующие карты: #{dealer.send(:show_sleeve)}." \
    "Количество очков: #{dealer.send(:show_points)}." \
    "У игрока #{player.name} следующие карты: #{player.send(:show_sleeve)} " \
    "Количество очков: #{player.send(:show_points)}"
  end

  def calculate_winner
    dealer_points = dealer.send(:show_points)
    player_points = player.send(:show_points)
    dealer_points_diff = (21 - dealer_points).abs
    player_points_diff = (21 - player_points).abs
    return if dealer_points == player_points
    return dealer if (dealer_points <= 21 && player_points > 21) || (dealer_points_diff < player_points_diff)
    return player if (player_points <= 21 && dealer_points > 21) || (player_points_diff < dealer_points_diff)
  end

  def bank_control(winner)
    winner.nil? ? draw(TAX) : win(winner)
  end

  def win(winner)
    self.session_bank = 0
    winner.get_win session_bank
  end

  def draw(money)
    self.session_bank -= money
    player.get_win money
    dealer.get_win money
  end

  def init_cards_distribution
    player.add_card cards_issuance, cards_issuance
    dealer.add_card cards_issuance, cards_issuance
  end

  def session_bid
    player_payment = player.bid(TAX)
    dealer_payment = dealer.bid(TAX)
    raise "#{player.name}, недостаточно денег для начала игры!" if player_payment.nil?
    raise 'Диллер повержен! Ты красавчик!' if dealer_payment.nil?

    top_up_game_bank player_payment, dealer_payment
  end

  def top_up_game_bank(*payments)
    payments.each { |payment| self.session_bank += payment }
  end

  def cards_issuance
    random_suit = cards.keys[Random.rand(cards.keys.size)]
    { suit: random_suit, point: cards[random_suit] }
  end

  def player_name(name)
    player.name = name
  end

  def fill_cards
    cards = {}
    suits = %W[\u2660 \u2665 \u2663 \u2666]
    ranks = %w[В Д К Т]
    suits.each do |suit|
      2.upto(10) do |i|
        cards["#{i}#{suit}"] = i
      end
      ranks.each do |rank|
        cards["#{rank}#{suit}"] = 10
      end
    end
    cards
  end
end
