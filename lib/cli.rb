require_relative '../config/environment.rb'

class CLI

	attr_accessor :current_user

	def welcome
		font = TTY::Font.new(:standard)
		pastel = Pastel.new
		starvin = Sound.new('./starvin.wav')
		puts pastel.bright_magenta.bold(font.write("Welcome  to"))
		sleep(2)
		puts pastel.bright_magenta.bold(font.write("Seriously,  Eat!"))
		sleep(2)
		puts pastel.bright_magenta.bold(font.write("Where  seriously..."))
		sleep(2)
		puts pastel.bright_magenta.bold(font.write("we  want  you  to  eat."))
		starvin.play
		sleep(3)
		puts pastel.bright_magenta.on_blue.bold("\nDo you have a 'Seriously, Eat!' account? (y/n)\n")
		choice = gets.chomp
		if choice == "y"
			puts pastel.bright_magenta.on_blue.bold("\nPlease enter your username:\n")
			username = gets.chomp
			if User.find_by(user_name: username)
				@current_user = User.find_by(user_name: username)
				self.options
			else
				puts pastel.bright_magenta.on_blue.bold("\nThis username does not exist. Would you like create an account? (y/n)\n")
					choice = gets.chomp
					self.account_option(choice)
			end
		elsif choice == "n"
			puts pastel.bright_magenta.on_blue.bold("\nWould you like create an account? (y/n)\n")
				choice = gets.chomp
				self.account_option(choice)
		end
	end

	def account_option(choice)
		pastel = Pastel.new(eachline: "\n")
		if choice == "y"
			self.create_new_user
			self.options
		elsif choice == "n"
			puts pastel.bright_magenta.on_blue.bold("\nGoodbye!\n")
		end
	end

	def create_new_user
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nPlease enter a new username:\n") 
		new_username = gets.chomp
		@current_user = User.create(user_name: new_username)
		puts pastel.bright_magenta.on_blue.bold("\nWelcome, #{new_username}. We hope you're hungry!\n")
	end

	def options
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nOPTIONS MENU\n")
		puts pastel.bright_magenta("Choose an option!")
		puts pastel.bright_magenta("1. Browse recipes")
		puts pastel.bright_magenta("2. View your Recipe Box (saved recipes)")
		puts pastel.bright_magenta("3. Exit\n")
		choice = gets.chomp
			if choice == "1" || choice == "1."
				self.browse_recipes
			elsif choice == "2" || choice == "2."
				self.view_recipe_box
			elsif choice == "3" || choice == "3."
				puts pastel.bright_magenta.on_blue.bold("\nGoodbye!\n")
				exit
			end
	end

	def browse_recipes
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nBROWSE RECIPES\n")
		puts pastel.bright_magenta("How would you like to search?")
		puts pastel.bright_magenta("1. Search by recipe name")
		puts pastel.bright_magenta("2. View popular recipes")
		puts pastel.bright_magenta("3. View healthy recipes")
		puts pastel.bright_magenta("4. View vegetarian recipes")
		puts pastel.bright_magenta("5. Return to Options Menu\n")
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
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nRECIPE OPTIONS\n")
		puts pastel.bright_magenta("The recipe you've selected is: '#{recipe_title}''")
		puts pastel.bright_magenta("\nSelect an option:")
		puts pastel.bright_magenta("1. View website for this recipe")
		puts pastel.bright_magenta("2. Save recipe to Recipe Box")
		puts pastel.bright_magenta("3. Go back to Browse Recipes\n")
		response = gets.chomp
		if response == "1" || response == "1."
			self.load_recipe_url(recipe_title)
			self.recipe_options(recipe_title)
		elsif response == "2" || response == "2."
			current_recipe = Recipe.find_by(title: recipe_title)
			RecipeBox.create(user_id: @current_user.id, recipe_id: current_recipe.id)
			puts pastel.bright_magenta("Your recipe '#{recipe_title}' has been saved.\n")
			self.recipe_options(recipe_title)
		elsif response == "3" || response == "3."
			self.browse_recipes
		end
	end

	def search_by_name
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nSEARCH RECIPES BY NAME\n")
		puts pastel.bright_magenta("Please enter a search term:\n")
		search_term = gets.chomp
		results = Recipe.where("title LIKE ?", "%" + search_term + "%").pluck(:title)
			until !results.empty?
				puts pastel.bright_magenta("No matching results, please try again:\n")
				search_term = gets.chomp
				"\n"
				results = Recipe.where("title LIKE ?", "%" + search_term + "%").pluck(:title)
			end
		results.each_with_index { |r, i| puts pastel.bright_magenta("#{i.next}. #{r}") }
		puts pastel.bright_magenta("Please select a recipe number or enter 'exit' to return to Browse Recipes:\n")        
		recipe_number = gets.chomp 
		self.browse_recipes if recipe_number == "exit"
		index = recipe_number.to_i - 1
		recipe_title = results[index]
		self.recipe_options(recipe_title)
	end
	
	def search_by_popular
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nPOPULAR RECIPES:\n")
		results = Recipe.where(very_popular: true).pluck(:title)
		results.each_with_index { |r, i| puts pastel.bright_magenta("#{i.next}. #{r}") }
		puts pastel.bright_magenta("Please select a recipe number or enter 'exit' to return to Browse Recipes:\n")  
		recipe_number = gets.chomp 
		self.browse_recipes if recipe_number == "exit"      
		index = recipe_number.to_i - 1
		recipe_title = results[index]
		self.recipe_options(recipe_title)
	end

	def search_by_healthy
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nHEALTHY RECIPES:")
		results = Recipe.where(very_healthy: true).pluck(:title)
		results.each_with_index { |r, i| puts pastel.bright_magenta("#{i.next}. #{r}") }
		puts pastel.bright_magenta("Please select a recipe number or enter 'exit' to return to Browse Recipes:\n")     
		recipe_number = gets.chomp
		self.browse_recipes if recipe_number == "exit"
		index = recipe_number.to_i - 1
		recipe_title = results[index]
		self.recipe_options(recipe_title)
	end

	def search_by_vegetarian
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nVEGETARIAN RECIPES:\n")
		results = Recipe.where(vegetarian: true).pluck(:title)
		results.each_with_index { |r, i| puts pastel.bright_magenta("#{i.next}. #{r}") }
		puts pastel.bright_magenta("Please select a recipe number or enter 'exit' to return to Browse Recipes:\n")        
		recipe_number = gets.chomp
		self.browse_recipes if recipe_number == "exit"
		index = recipe_number.to_i - 1
		recipe_title = results[index]
		self.recipe_options(recipe_title)
	end

	def view_recipe_box
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nYOUR RECIPE BOX\n")
		results = RecipeBox.where(user_id: @current_user.id)
			if results.empty?
				puts pastel.bright_magenta("Your Recipe Box is empty")
				self.options
			elsif !results.empty?
				results.each_with_index { |r, i| puts pastel.bright_magenta("#{i.next}. #{Recipe.find(r.recipe_id).title}")}
				puts pastel.bright_magenta("Please select a recipe number to view the recipe, view or add a note to the recipe, or remove it from your Recipe Box.")
				puts pastel.bright_magenta("Or enter 'exit' to return to Options Menu")
				recipe_number = gets.chomp
				self.options if recipe_number == "exit"
				index = recipe_number.to_i - 1
				recipe_title = Recipe.find(results[index].recipe_id).title
				modify_recipe_box(recipe_title)
			end
	end

	def modify_recipe_box(recipe_title)
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nSAVED RECIPE OPTIONS\n")
		puts pastel.bright_magenta("The saved recipe you've selected is: '#{recipe_title}''")
		puts pastel.bright_magenta("Select an option:")
		puts pastel.bright_magenta("1. View website for this recipe")
		puts pastel.bright_magenta("2. View your note for this recipe")
		puts pastel.bright_magenta("3. Add/update note to this recipe")
		puts pastel.bright_magenta("4. Remove note from this recipe")
		puts pastel.bright_magenta("5. Remove this recipe from your Recipe Box")
		puts pastel.bright_magenta("6. Go back to Recipe Box\n")
		choice = gets.chomp
			if choice == "1" || choice == "1."
				self.load_recipe_url(recipe_title) 
				self.modify_recipe_box(recipe_title)
			elsif choice == "2" || choice == "2."
				self.view_recipe_note(recipe_title)
			elsif choice == "3" || choice == "3."
				self.add_note_to_recipe(recipe_title)
			elsif choice == "4" || choice == "4."
				self.remove_note_from_recipe(recipe_title)
			elsif choice == "5" || choice == "5."
				self.remove_recipe(recipe_title)
			elsif choice == "6" || choice == "6."
				self.view_recipe_box
			end
	end

	def view_recipe_note(recipe_title)
		pastel = Pastel.new(eachline: "\n")
		if RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note != nil
			puts RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note
		elsif RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note == nil
			puts pastel.bright_magenta("There is no note for this recipe")
			self.modify_recipe_box(recipe_title)
		end
		self.modify_recipe_box(recipe_title)
	end

	def add_note_to_recipe(recipe_title)
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta.on_blue.bold("\nADD/UPDATE NOTE TO RECIPE\n")
		puts pastel.bright_magenta("Recipe to add note to: '#{recipe_title}'")
		puts pastel.bright_magenta("Please type the note you would like to add:")
		note = gets.chomp
		RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).update(recipe_note: note)
		puts pastel.bright_magenta("Your note has been added to your recipe: '#{recipe_title}'")
		self.modify_recipe_box(recipe_title)
	end

	def remove_note_from_recipe(recipe_title)
		pastel = Pastel.new(eachline: "\n")
		RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).update(recipe_note: nil)
		puts pastel.bright_magenta("This note was removed from your recipe: '#{recipe_title}'")
		self.view_recipe_box
	end

	def remove_recipe(recipe_title)
		pastel = Pastel.new(eachline: "\n")
		puts pastel.bright_magenta("This recipe was removed from your Recipe Box: '#{recipe_title}'")
		RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).destroy
		self.view_recipe_box
	end

	def load_recipe_url(recipe_title)
		url_array = Recipe.where(title: recipe_title).pluck(:source_url)
		url = url_array[0]
		system("open", "#{url}") 
	end
	
end