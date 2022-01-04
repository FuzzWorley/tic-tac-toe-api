class Api::V1::GamesController < ApplicationController
  def index
    @games = Game.all
    json_response(@games)
  end
end
