class Recipe < ActiveRecord::Base
  has_many :recipe_boxes
	has_many :users, through: :recipe_boxes
end