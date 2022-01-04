class Game < ApplicationRecord
  attr_accessor :board

  after_initialize :set_new_board, unless: :persisted?

  PLAYERS = ['x', 'o']

  validates_presence_of :board

  def move(row_value, column_value, player)
    raise TileUnavailableError if board[row_value, column_value].present?

    update_game_for_move(row_value, column_value, player)
    search_for_and_set_winner
    return update!(winner: @victor) if @victor.present?
    update!(winner: 'draw') if moves == 9
  end

  private

  def victor(array)
    @victor ||= array.uniq.first if array.uniq.size <= 1
  end

  def search_for_and_set_winner
    3.times do |n| 
      victor(board[n, 0..2])
      victor(board.transpose[n, 0..2])
      break if @victor.present?
    end

    victor(backslash_values)
    victor(forwardslash_values)
  end

  def backslash_values
    (0..2).collect { |i| board[i, i] }
  end

  def forwardslash_values
    (0..2).collect { |i| board[i, 2 - i] }
  end

  def set_new_board
    self.board = Matrix[[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
  end
  
  def update_game_for_move(row_value, column_value, player)
    self.board[row_value, column_value] = player
    self.moves += 1
    self.save!
  end
end
