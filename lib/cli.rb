require_relative '../config/environment.rb'

class CLI 

	def welcome
		puts "Welcome to 'Seriously, Eat!' Where seriously, we want you to eat."
		puts "Do you have a 'Seriously, Eat!' account? (y/n)"
		response = gets.chomp
		if response == "y"
			puts "Please enter your username:"
			username = gets.chomp
			if User.find_by(user_name: username)
				self.options
			else
				puts "This username does not exist. Would you like create an account? (y/n)"
					choice = gets.chomp
					self.account_option(choice)
			end
		elsif response == "n"
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
		puts "Choose an option!"
		puts "1. Browse Recipes"
		puts "2. View Your Recipe Box"
		puts "3. Exit"
		choice = gets.chomp 
	end

	def search_recipes
		puts "Which recipe are you looking for?"
		search_term = gets.chomp
		# 1. RestClient.get("spotify.api/searchQuery")
		# 2. JSON.parse
		# 3. Let the user make some choices 
		# 4. Say they choose a favorite, make the updates to your 
		#     DB to save the song info you need easy access to and to represent the favorite 
	end

end