class TileUnavailableError < StandardError
  def initialize
    super('This tile has already been played.')
  end
end