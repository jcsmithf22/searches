class CreatePins < ActiveRecord::Migration[8.1]
  def change
    create_table :pins do |t|
      t.references :user, null: false, foreign_key: true
      t.references :search, null: false, foreign_key: true

      t.timestamps
    end

    add_index :pins, [ :user, :search ], unique: true
  end
end
