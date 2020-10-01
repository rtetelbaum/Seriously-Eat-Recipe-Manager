require_relative '../config/environment.rb'
require_relative '../.spoon.rb'

User.delete_all
RecipeBox.delete_all
Recipe.delete_all

#https://api.spoonacular.com/recipes/716429/information?apiKey=YOUR-API-KEY

api_response = RestClient.get("https://api.spoonacular.com/recipes/random?number=100&apiKey=#{$spoon_key}")

api_data = JSON.parse(api_response)

api_data["recipes"].each do |recipe|
	title = recipe["title"]
	very_popular = recipe["veryPopular"]
	very_healthy = recipe["veryHealthy"]
	vegetarian = recipe["vegetarian"]
	source_url = recipe["spoonacularSourceUrl"]
	Recipe.create(title: title, very_popular: very_popular, very_healthy: very_healthy, vegetarian: vegetarian, source_url: source_url)
end