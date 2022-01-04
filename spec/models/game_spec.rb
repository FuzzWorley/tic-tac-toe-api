require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should validate_presence_of(:board) }

  it 'has the correct PLAYERS' do
    expect(described_class::PLAYERS).to eq(['x', 'o'])
  end

  describe '#move' do
    subject { game.move(row_value, column_value, player) }

    let(:game) { create(:game) }
    let(:row_value) { Faker::Number.within(range: 0..2) }
    let(:column_value) { Faker::Number.within(range: 0..2) }
    let(:player) { described_class::PLAYERS.sample }

    it 'updates the board correctly' do
      expect { subject }.to change { game.board[row_value, column_value] }
        .from(nil).to(player)
    end

    it 'updates the moves count correctly' do
      expect { subject }.to change { game.moves }.from(0).to(1)
    end

    context 'when there a player is already occupying the square' do
      before do
        game.board[row_value, column_value] = player
        game.save!
      end

      it 'throws an exception' do
        expect { subject }.to raise_error(
          TileUnavailableError, "This tile has already been played."
        )
      end
    end

    context 'when a player wins horizontally' do
      let(:row_value) { 2 }
      let(:column_value) { 2 }
      let(:player) { 'o' }

      before do
        game.update!(board: Matrix[
          [nil, 'x', nil],
          ['x', 'x', nil],
          ['o', 'o', nil]
        ])
      end

      it 'updates the winner' do
        expect { subject }.to change { game.winner }.from(nil).to('o')
      end
    end

    context 'when a player wins vertically' do
      let(:row_value) { 2 }
      let(:column_value) { 1 }
      let(:player) { 'x' }

      before do
        game.update!(board: Matrix[
          [nil, 'x', 'o'],
          [nil, 'x', nil],
          [nil, nil, 'o']
        ])
      end

      it 'updates the winner' do
        expect { subject }.to change { game.winner }.from(nil).to('x')
      end
    end

    context 'when a player wins forward slash diagnol' do
      let(:row_value) { 1 }
      let(:column_value) { 1 }
      let(:player) { 'o' }

      before do
        game.update!(board: Matrix[
          [nil, nil, 'o'],
          [nil, nil, nil],
          ['o', nil, nil]
        ])
      end

      it 'updates the winner' do
        expect { subject }.to change { game.winner }.from(nil).to('o')
      end
    end

    context 'when a player wins backslash diagnol' do
      let(:row_value) { 2 }
      let(:column_value) { 2 }
      let(:player) { 'x' }

      before do
        game.update!(board: Matrix[
          ['x', nil, nil],
          [nil, 'x', nil],
          [nil, nil, nil]
        ])
      end

      it 'updates the winner' do
        expect { subject }.to change { game.winner }.from(nil).to('x')
      end
    end

    context 'when a draw is reached' do
      let(:row_value) { 2 }
      let(:column_value) { 2 }
      let(:player) { 'x' }
      before do
        game.update!(
          board: Matrix[
            ['x', 'x', 'o'],
            ['o', 'o', 'x'],
            ['x', 'o', nil]
          ],
          moves: 8
        )
      end

      it 'updates the winner' do
        expect { subject }.to change { game.winner }.from(nil).to('draw')
      end
    end
  end
end