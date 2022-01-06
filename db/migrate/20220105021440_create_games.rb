class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :moves, default: 0
      t.string :tiles, array: true, default: [[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]
      t.string :winner

      t.timestamps
    end
  end
end
