require_relative '../config/environment.rb'

#https://api.spoonacular.com/recipes/716429/information?apiKey=YOUR-API-KEY

api_response = RestClient.get("https://api.spoonacular.com/recipes/random?number=1&apiKey=2fc3b45cc13341e0bf1c9db7a97b72e4")

api_data = JSON.parse(api_response)

# api_data["recipes"][0]["title"]
# api_data["recipes"][0]["veryPopular"]
# api_data["recipes"][0]["veryHealthy"]
# api_data["recipes"][0]["vegetarian"]
# api_data["recipes"][0]["spoonacularSourceUrl"]