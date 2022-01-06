class Game < ApplicationRecord
  PLAYERS = ['x', 'o']

  def move(params)
    row, column, player = params['row'].to_i, params['column'].to_i, params['player']
    raise GameOverError.new(winner) if winner.present?
    raise TileUnavailableError if tiles[row][column].present?

    update_game_for_move(row, column, player)
    search_for_and_set_winner
    return update!(winner: @winner) if @winner.present?
    update!(winner: 'draw') if moves == 9
  end

  private

  def assign_winner_if_won(array)
    @winner ||= array.uniq.first if array.uniq.size <= 1
  end

  def search_for_and_set_winner
    3.times do |n| 
      assign_winner_if_won(row_values(n))
      assign_winner_if_won(column_values(n))
      return if @winner.present?
    end

    assign_winner_if_won(backslash_values)
    assign_winner_if_won(forwardslash_values)
  end

  def row_values(n)
    tiles[n][0..2]
  end

  def column_values(n)
    tiles.transpose[n][0..2]
  end

  def backslash_values
    (0..2).collect { |i| tiles[i][i] }
  end

  def forwardslash_values
    (0..2).collect { |i| tiles[i][2 - i] }
  end
  
  def update_game_for_move(row, column, player)
    self.tiles[row][column] = player
    self.moves += 1
    self.save!
  end
end
