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
    puts 'Ставки сделаны и внесены в банк игры - ставок больше нет'
    loop do
      if player_turn
        player_game
      else
        dealer_game
      end
      change_turn
    end
  end

  def player_game
    puts "#{player.name}, сейчас ваш ход!\nВы можете сделать следующее:\n1)Пропустить ход\n2)Добавить карту\n" \
    '3)Открыть карты'
    player_actions = {
      2 => -> { player.add_card cards_issuance }
    }
  end

  def dealer_game
    dealer.add_card cards_issuance if dealer.send(:show_points) < 17
  end

  def change_turn
    player_turn ? (self.player_turn = false) : (self.player_turn = true)
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
    random_card = cards.keys[Random.rand(cards.keys.size)]
    { random_card => cards[random_card] }
  end

  def player_name(name)
    player.name = name
  end

  def fill_cards
    cards = {}
    suits = %W[\u2660 \u2665 \u2663 \u2666]
    ranks = %w[В Д К Т]
    suits.each do |suit|
      # Заполняем обычный номинал
      2.upto(10) do |i|
        cards["#{i}#{suit}"] = i
      end
      # Заполняем "картинки"
      ranks.each do |rank|
        cards["#{rank}#{suit}"] = 10
      end
    end
    cards
  end
end
