require_relative '../config/environment.rb'

class CLI 

	def welcome
		puts "Welcome to 'Seriously, Eat!' Where seriously, we want you to eat."
		puts "Do you have a 'Seriously, Eat!' account? (y/n)"
		choice = gets.chomp
		if choice == "y"
			puts "Please enter your username:"
			username = gets.chomp
			if User.find_by(user_name: username)
				self.options
			else
				puts "This username does not exist. Would you like create an account? (y/n)"
					choice = gets.chomp
					self.account_option(choice)
			end
		elsif choice == "n"
			puts "Would you like create an account? (y/n)"
				choice = gets.chomp
				self.account_option(choice)
		end
	end

	def account_option(choice)
		if choice == "y"
			self.create_new_user
		elsif choice == "n"
			puts "Goodbye!"
		end
	end

	def create_new_user
		puts "Please enter a new username." 
		new_username = gets.chomp
		User.create(user_name: new_username)
		puts "Welcome, #{new_username}. We hope you're hungry!"
	end

	def options
		puts "OPTIONS MENU"
		puts "Choose an option!"
		puts "1. Browse recipes"
		puts "2. View your recipe box"
		puts "3. Exit"
		choice = gets.chomp
			if choice == "1" || "1."
				self.browse_recipes #helper method TBD
			elsif choice == "2" || "2."
				self.recipe_box #helper method TBD
			elsif choice == "3" || "3."
				puts "Goodbye!"
			end
	end

	def browse_recipes
		puts "BROWSE RECIPES"
		puts "How would you like to search?"
		puts "1. Search by recipe name"
		puts "2. View popular recipes"
		puts "3. View healthy recipes"
		puts "4. View vegetarian recipes"
		puts "5. Return to OPTIONS MENU"


		# puts "Which recipe are you looking for?"
		# search_term = gets.chomp
		# 1. RestClient.get("spotify.api/searchQuery")
		# 2. JSON.parse
		# 3. Let the user make some choices 
		# 4. Say they choose a favorite, make the updates to your 
		#     DB to save the song info you need easy access to and to represent the favorite 
	end

end