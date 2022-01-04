class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :board, array: true
      t.integer :moves, default: 0, null: false
      t.string :winner

      t.timestamps
    end
  end
end
