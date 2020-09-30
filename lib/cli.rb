require_relative '../config/environment.rb'

class CLI 

	def welcome
		puts "Welcome to 'Seriously, Eat!' Where seriously, we want you to eat."
		puts "\nDo you have a 'Seriously, Eat!' account? (y/n)"
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
		puts "\nOPTIONS MENU"
		puts "Choose an option!"
		puts "1. Browse recipes"
		puts "2. View your recipe box"
		puts "3. Exit"
		choice = gets.chomp
			if choice == "1" || choice == "1."
				self.browse_recipes
			elsif choice == "2" || choice == "2."
				puts "recipe box under construction"
				self.options
				#self.recipe_box #helper method TBD
			elsif choice == "3" || choice == "3."
				puts "Goodbye!"
			end
	end

	def browse_recipes
		puts "\nBROWSE RECIPES"
		puts "How would you like to search?"
		puts "1. Search by recipe name"
		puts "2. View popular recipes"
		puts "3. View healthy recipes"
		puts "4. View vegetarian recipes"
		puts "5. Return to OPTIONS MENU"
		choice = gets.chomp
			if choice == "1" || choice == "1."
				self.search_by_name
			elsif choice == "2" || choice == "2."
				self.search_by_popular
			elsif choice == "3" || choice == "3."
				self.search_by_healthy
			elsif choice == "4" || choice == "4."
				self.search_by_vegetarian
			elsif choice == "5" || choice == "5."
				self.options
			end
	end

	def search_by_name
		puts "\nSEARCH RECIPES BY NAME"
		puts "Please enter a search term:"
		search_term = gets.chomp
		Recipe.where("title LIKE ?", "%" + search_term + "%").pluck(:title).each_with_index { |r, i| puts "#{i.next}. #{r}" }
		self.recipe_options
		self.browse_recipes
	end
	
	def search_by_popular
		puts "\nPOPULAR RECIPES:"
		Recipe.where(very_popular: true).pluck(:title).each_with_index { |r, i| puts "#{i.next}. #{r}" }
		self.recipe_options
		self.browse_recipes
	end

	def search_by_healthy
		puts "\nHEALTHY RECIPES:"
		Recipe.where(very_healthy: true).pluck(:title).each_with_index { |r, i| puts "#{i.next}. #{r}" }
		self.recipe_options
		self.browse_recipes
	end

	def search_by_vegetarian
		puts "\nVEGETARIAN RECIPES:"
		Recipe.where(vegetarian: true).pluck(:title).each_with_index { |r, i| puts "#{i.next}. #{r}" }
		self.recipe_options
		self.browse_recipes
	end

	def recipe_options
		puts "\nRECIPE OPTIONS"
	end
	
end