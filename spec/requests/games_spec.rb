require 'rails_helper'

RSpec.describe 'Games API', type: :request do
  let!(:games) { create_list(:game, 5) }
  let(:game) { games.first }
  let(:id) { games.first.id }

  describe 'GET /games' do
    before do
      get '/api/v1/games'
    end

    it 'returns games' do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(5)
      expect(JSON.parse(response.body)[0]['tiles'] ).to eq(
        [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
      )
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /games/:id' do
    before { get "/api/v1/games/#{id}" }

    context 'when game exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the game' do
        expect(JSON.parse(response.body)['id']).to eq(id)
      end
    end

    context 'when game game does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Game with 'id/)
      end
    end
  end

  describe 'POST /games' do
    context 'when the request is valid' do
      before { post '/api/v1/games' }

      it 'creates a game with correct attributes' do
        expect(Game.all.count).to eq(6)
        expect(JSON.parse(response.body)['tiles'] ).to eq(
          [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
        )
        expect(JSON.parse(response.body)['moves'] ).to eq(0)
        expect(JSON.parse(response.body)['winner'] ).to eq(nil)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'PUT /api/v1/games/:id' do
    let(:valid_attributes) { { row: 0, column: 1, player: 'x' } }

    context 'when the record exists' do
      before { put "/api/v1/games/#{id}", params: valid_attributes }

      it 'updates the record' do
        expect(JSON.parse(response.body)['tiles'] ).to eq(
          [[nil, 'x', nil], [nil, nil, nil], [nil, nil, nil]]
        )
        expect(JSON.parse(response.body)['moves'] ).to eq(1)
        expect(JSON.parse(response.body)['winner'] ).to eq(nil)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the game is already won' do
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
        put "/api/v1/games/#{id}", params: valid_attributes
      end

      it 'returns status code 400 bad request' do
        expect(response).to have_http_status(400)
      end
    end

    context 'when a tile is already played' do
      let(:invalid_attributes) { { row: 0, column: 0, player: 'o' } }

      before do
        game.update!(
          tiles: [
            ['x', nil, nil],
            [nil, nil, nil],
            [nil, nil, nil]
          ],
          moves: 1,
          winner: nil
        )
        put "/api/v1/games/#{id}", params: invalid_attributes
      end

      it 'returns status code 400 bad request' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'DELETE /api/v1/games/:id' do
    before { delete "/api/v1/games/#{id}" }

    it 'deletes the object' do
      expect(Game.all.count).to eq(4)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end