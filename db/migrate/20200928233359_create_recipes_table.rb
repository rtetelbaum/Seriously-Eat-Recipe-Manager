class CreateRecipesTable < ActiveRecord::Migration[6.0]
  def change
		create_table :recipes do |t|
			t.string :title
			t.string :very_popular
			t.string :very_healthy
			t.string :vegetarian
			t.string :source_url
		end
  end
end
