class CreateRecipeBoxesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :recipe_boxes do |t|
      t.integer :user_id
      t.integer :recipe_id
      t.string :recipe_note
    end
  end
end