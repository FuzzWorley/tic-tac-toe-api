class Api::V1::GamesController < ApplicationController
  def index
    @games = Game.all
    json_response(@games)
  end

  def show
    @game = Game.find(params[:id])
    json_response(@game)
  end

  def create
    @game = Game.create!
    json_response(@game, :created)
  end

  def update
    @game = Game.find(params[:id])
    @game.move(params)
    json_response(@game)
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    json_response(@game)
  end
end
