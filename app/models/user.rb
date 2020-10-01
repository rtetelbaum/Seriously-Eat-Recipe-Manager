class User < ActiveRecord::Base
	has_many :recipe_boxes
	has_many :recipes, through: :recipe_boxes
end