class GameOverError < StandardError
  def initialize(winner)
    super("Game already over - winner: #{winner} Can not be updated.")
  end
end