## Tic Tac Toe API
Welcome! Play Tic Tac Toe with your friend via Postman or curl.  
Or maybe build a front end app to interface.  
Or maybe just google tic tac toe and play right in your web browser :)

## Tic Tac Toe Instructions
There are two players: "x" and "o". The board is a 3x3 grid of tiles.  
Players alternate turns placing their respective "x" or "o" on any unoccupied grid.  
The goal is to occupy any 3 tiles through which a straight line could be drawn.  
If all 9 tiles are occupied and no winner is present, the game is a draw.


## Sample Requests
The API is hosted at the following URL: `https://serene-ravine-84304.herokuapp.com`.

Or you may run your own local server if you are keen on setting up a Rails / Postgres ENV or if you already have one!

* Create new game
  * POST `/api/v1/games`
* Update a game, or "move"
  * PUT `/api/v1/games/:game_id`
    * sample params: `row=1&column=2&player=x`
    * these params would place an "x" in the middle tile, as the row and column indices start at 0
* Get all games
    * GET `/api/v1/games`
* Get a specific game
    * GET `/api/v1/games/:game_id`

## Technical details
* Ruby version "3.0.2"
* Rails version: "~> 7.0.0"
* Postgres database
* Puma server
* Rspec / Factorybot testing
