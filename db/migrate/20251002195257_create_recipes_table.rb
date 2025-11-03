class CreateRecipesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :cook_time, null: false
      t.string :difficulty, null: false
      t.text :instructions
      t.timestamps
    end
  end
end
