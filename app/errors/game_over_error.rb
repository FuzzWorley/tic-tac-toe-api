class GameOverError < StandardError
  def initialize(winner)
    super("Game over - winner: #{winner} Can not be updated.")
  end
end