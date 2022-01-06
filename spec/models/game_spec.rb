require 'rails_helper'

RSpec.describe Game, type: :model do

  it 'has the correct PLAYERS' do
    expect(described_class::PLAYERS).to eq(['x', 'o'])
  end

  describe '#move' do
    subject { game.move( params ) }

    let(:game) { create(:game) }
    let(:row) { Faker::Number.within(range: 0..2) }
    let(:column) { Faker::Number.within(range: 0..2) }
    let(:player) { described_class::PLAYERS.sample }
    let(:params) { 
      { row: row, column: column, player: player }.with_indifferent_access
    }

    it 'updates the tiles correctly' do
      expect { subject }.to change { game.tiles[row][column] }
        .from(nil).to(player)
    end

    it 'updates the moves count correctly' do
      expect { subject }.to change { game.moves }.from(0).to(1)
    end

    context 'when a player wins horizontally' do
      let(:row) { 2 }
      let(:column) { 2 }
      let(:player) { 'o' }

      before do
        game.update!(tiles: [
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
      let(:row) { 2 }
      let(:column) { 1 }
      let(:player) { 'x' }

      before do
        game.update!(tiles: [
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
      let(:row) { 1 }
      let(:column) { 1 }
      let(:player) { 'o' }

      before do
        game.update!(tiles: [
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
      let(:row) { 2 }
      let(:column) { 2 }
      let(:player) { 'x' }

      before do
        game.update!(tiles: [
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
      let(:row) { 2 }
      let(:column) { 2 }
      let(:player) { 'x' }
      before do
        game.update!(
          tiles: [
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

    context 'when the game already has a winner' do
      let(:row) { 2 }
      let(:column) { 2 }
      let(:player) { 'x' }
      before do
        game.update!(
          tiles: [
            ['x', 'x', nil],
            ['o', 'o', 'o'],
            [nil, nil, nil]
          ],
          moves: 5,
          winner: 'o'
        )
      end

      it 'updates raises GameOverError' do
        expect { subject }.to raise_error(
          GameOverError, "Game already over - winner: #{game.winner} Can not be updated."
        )
      end
    end

    context 'when there a player is already occupying the square' do
      before do
        game.tiles[row][column] = player
        game.save!
      end

      it 'throws an exception' do
        expect { subject }.to raise_error(
          TileUnavailableError, "This tile has already been played."
        )
      end
    end
  end
end