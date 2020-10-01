require_relative '../config/environment.rb'

class CLI

	attr_accessor :current_user

	def welcome
		puts "\nWelcome to 'Seriously, Eat!' Where seriously, we want you to eat."
		puts "\nDo you have a 'Seriously, Eat!' account? (y/n)"
		choice = gets.chomp
		if choice == "y"
			puts "Please enter your username:"
			username = gets.chomp
			if User.find_by(user_name: username)
				@current_user = User.find_by(user_name: username)
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
		@current_user = User.create(user_name: new_username)
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

	def recipe_options(recipe_title)
		puts "\nRECIPE OPTIONS"
		puts "The recipe you've selected is: #{recipe_title}"
		puts "Select an option:"
		puts "1. View website for this recipe"
		puts "2. Save recipe to Recipe Box"
		puts "3. Go back to Browse Recipes"
		response = gets.chomp
		if response == "1" || response == "1."
			url_array = Recipe.where(title: recipe_title).pluck(:source_url)
			url = url_array[0]
			system("open", "#{url}") 
		elsif response == "2" || response == "2."
			current_recipe = Recipe.find_by(title: recipe_title)
			RecipeBox.create(user_id: @current_user.id, recipe_id: current_recipe.id)
			puts "your recipe #{recipe_title} has been saved."
		elsif response == "3" || response == "3."
			self.browse_recipes
		end
	end

	def search_by_name
		puts "\nSEARCH RECIPES BY NAME"
		puts "Please enter a search term:"
		search_term = gets.chomp
		results = Recipe.where("title LIKE ?", "%" + search_term + "%").pluck(:title)
			until results != []
				puts "No matching results, please try again:"
				search_term = gets.chomp
				results = Recipe.where("title LIKE ?", "%" + search_term + "%").pluck(:title)
			end
		results.each_with_index { |r, i| puts "#{i.next}. #{r}" }
		puts "Please select a recipe number:"
		recipe_number = gets.chomp
		index = recipe_number.to_i - 1
		recipe_title = results[index]
		self.recipe_options(recipe_title)
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

	def view_recipe_box
		# puts saved recipes list, or says empty
		# select recipe by number, if !number puts this number doesn't exist, if exists call modify_recipe_box
		# go back to options
	end

	def modify_recipe_box
		# view website url and stay in this menu
		# add note to recipe calls add_note_to_recipe
		# remove recipe from recipe box calls remove_recipe
		# back to view_recipe_box
	end

	def add_note_to_recipe
		# prompt for string note
		# add string to recipe_note column for that recipe
		# puts not added
		# returns to view_recipe_box
	end

	def remove_recipe
		# removes the recipe
		# puts removed, then return to view_recipe box
	end
	
end