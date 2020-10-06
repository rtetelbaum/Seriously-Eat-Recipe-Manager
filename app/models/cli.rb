require_relative '../../config/environment.rb'

class CLI

	attr_accessor :current_user, :pastel

	$pastel = Pastel.new(eachline: "\n")
	$prompt = TTY::Prompt.new

	def welcome
		font = TTY::Font.new(:standard)
		starvin = Sound.new('./starvin.wav')
		puts $pastel.bright_magenta.bold(font.write("Welcome  to"))
		sleep(1)
		puts $pastel.bright_magenta.bold(font.write("Seriously,  Eat!"))
		sleep(1)
		puts $pastel.bright_magenta.bold(font.write("Where  seriously..."))
		sleep(3)
		puts $pastel.bright_magenta.bold(font.write("we  want  you  to  eat."))
		starvin.play
		sleep(4)
		puts ""
		choice = $prompt.yes?("Do you have a 'Seriously, Eat!' account?")
		system("clear")
		if choice == true
			username = $prompt.ask("Please enter your username:")
			puts ""
			if User.find_by(user_name: username)
				@current_user = User.find_by(user_name: username)
				system("clear")
				self.options
			else
				choice = $prompt.yes?("This username does not exist. Would you like create an account?")
				system("clear")
				self.account_option(choice)
			end
		elsif choice == false
			choice = $prompt.yes?("Would you like create an account?")
				system("clear")
				self.account_option(choice)
		end
	end

	def account_option(choice)
		if choice == true
			self.create_new_user
			self.options
		elsif choice == false
			system("clear")
			puts "Goodbye!"
			puts ""
		end
	end

	def create_new_user
		new_username = $prompt.ask("Please enter a new username:")
		system("clear")
		if !User.find_by(user_name: new_username)
			@current_user = User.create(user_name: new_username)
			puts "Welcome, #{@current_user.user_name}. We hope you're hungry!"
			puts ""
		else
			puts "The username '#{new_username}' is already taken, please try again."
			puts ""
			self.create_new_user
		end
	end

	def options
		choice = $prompt.select($pastel.bright_magenta.on_blue.bold("OPTIONS MENU")) do |menu|
			menu.choice "Browse recipes", 1
			menu.choice "View your Recipe Box (saved recipes)", 2
			menu.choice "Exit", 3
		end
		system("clear")
		if choice == 1
			self.browse_recipes
		elsif choice == 2
			self.view_recipe_box
		elsif choice == 3
			puts "Goodbye!"
			puts ""
			exit
		end
	end

	def browse_recipes
		puts $pastel.bright_magenta.on_blue.bold("BROWSE RECIPES")
		choice = $prompt.select("How would you like to search?") do |menu|
		menu.choice "Search by recipe name", 1
		menu.choice "View popular recipes", 2
		menu.choice "View healthy recipes", 3
		menu.choice "View vegetarian recipes", 4
		menu.choice "RETURN TO Options Menu", 5
		end
		system("clear")
		if choice == 1
			self.search_by_name
		elsif choice == 2
			self.search_by_popular
		elsif choice == 3
			self.search_by_healthy
		elsif choice == 4
			self.search_by_vegetarian
		elsif choice == 5
			self.options
		end
	end

	def recipe_options(recipe_title)
		puts $pastel.bright_magenta.on_blue.bold("RECIPE OPTIONS")
		puts ""
		puts "The recipe you've selected is: '#{recipe_title}'"
		puts ""
		choice = $prompt.select("Enter an option number:") do |menu|
		menu.choice "View website for this recipe", 1
		menu.choice "Save recipe to Recipe Box", 2
		menu.choice "GO BACK to Browse Recipes", 3
		end
		system("clear")
		if choice == 1
			self.load_recipe_url(recipe_title)
			self.recipe_options(recipe_title)
		elsif choice == 2
			current_recipe = Recipe.find_by(title: recipe_title)
			if RecipeBox.find_by(user_id: @current_user.id, recipe_id: current_recipe.id)
				system("clear")
				puts "This recipe is already in your recipe box."
				puts ""
				self.recipe_options(recipe_title)
			else
				RecipeBox.create(user_id: @current_user.id, recipe_id: current_recipe.id)
				puts "Your recipe '#{recipe_title}' has been saved to your Recipe Box."
				puts ""
				self.recipe_options(recipe_title)
			end
		elsif choice == 3
			self.browse_recipes
		end
	end

	def search_by_name
		puts $pastel.bright_magenta.on_blue.bold("SEARCH RECIPES BY NAME")
		search_term = $prompt.ask("Please enter a search term:")
		puts ""
		results = Recipe.where("title LIKE ?", "%" + search_term + "%").pluck(:title)
			until !results.empty?
				search_term = $prompt.ask("No matching results, please try again:")
				results = Recipe.where("title LIKE ?", "%" + search_term + "%").pluck(:title)
				puts ""
			end
		recipe_results(results)
	end
	
	def search_by_popular
		puts $pastel.bright_magenta.on_blue.bold("POPULAR RECIPES:")
		results = Recipe.where(very_popular: true).pluck(:title)
		recipe_results(results)
	end

	def search_by_healthy
		puts $pastel.bright_magenta.on_blue.bold("HEALTHY RECIPES:")
		results = Recipe.where(very_healthy: true).pluck(:title)
		recipe_results(results)
	end

	def search_by_vegetarian
		puts $pastel.bright_magenta.on_blue.bold("VEGETARIAN RECIPES:")
		results = Recipe.where(vegetarian: true).pluck(:title)
		recipe_results(results)
	end

	def recipe_results(results)
		choices = results
		choices << "GO BACK to Browse Recipes"
		recipe_title = $prompt.select("Select a recipe:", choices)
		if recipe_title == "GO BACK to Browse Recipes"
			system("clear")
			self.browse_recipes
		else
			system("clear")
			self.recipe_options(recipe_title)
		end
	end

	def view_recipe_box
		puts $pastel.bright_magenta.on_blue.bold("YOUR RECIPE BOX")
		results = RecipeBox.where(user_id: @current_user.id).pluck(:recipe_id).collect { |id| Recipe.find(id).title }
		choices = results
		if results.empty?
			system("clear")
			puts "Your Recipe Box is empty."
			puts ""
			self.options
		elsif !results.empty?
			choices << "GO BACK to Options Menu"
			recipe_title = $prompt.select("Select a recipe to see it, view/add a note to it, or delete it from your Recipe Box:", choices)
			if recipe_title == "GO BACK to Options Menu"
				system("clear")
				self.options
			else
				system("clear")
				self.modify_recipe_box(recipe_title)
			end
		end
	end

	def modify_recipe_box(recipe_title)
		puts $pastel.bright_magenta.on_blue.bold("SAVED RECIPE OPTIONS")
		puts "The saved recipe you've selected is: '#{recipe_title}'"
		choice = $prompt.select("Enter an option number:") do |menu|
			menu.choice "Open website for this recipe", 1
			menu.choice "View your note for this recipe", 2
			menu.choice "Add/update note for this recipe", 3
			menu.choice "Remove note from this recipe", 4
			menu.choice "Delete this recipe from your Recipe Box", 5
			menu.choice "GO BACK to your Recipe Box", 6
		end
			if choice == 1
				self.load_recipe_url(recipe_title)
				system("clear")
				self.modify_recipe_box(recipe_title)
			elsif choice == 2
				system("clear")
				self.view_recipe_note(recipe_title)
			elsif choice == 3
				system("clear")
				self.add_note_to_recipe(recipe_title)
			elsif choice == 4
				system("clear")
				self.remove_note_from_recipe(recipe_title)
			elsif choice == 5
				system("clear")
				self.delete_recipe(recipe_title)
			elsif choice == 6
				system("clear")
				self.view_recipe_box
			end
	end

	def view_recipe_note(recipe_title)
		if RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note != nil
			puts "Your note for the recipe: '#{recipe_title}'"
			puts ""
			puts RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note
			puts ""
		elsif RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note == nil
			puts "There is no note for this recipe: '#{recipe_title}'"
			puts ""
			self.modify_recipe_box(recipe_title)
		end
		self.modify_recipe_box(recipe_title)
	end

	def add_note_to_recipe(recipe_title)
		puts $pastel.bright_magenta.on_blue.bold("ADD/UPDATE NOTE FOR RECIPE")
		puts "Recipe to add/update note for: '#{recipe_title}'"
		puts "Please type the note you would like to add:"
		puts ""
		note = gets.chomp
		puts ""
		RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).update(recipe_note: note)
		puts "Your note has been added for your recipe: '#{recipe_title}'"
		puts ""
		self.modify_recipe_box(recipe_title)
	end

	def remove_note_from_recipe(recipe_title)
		if RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note != nil
			RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).update(recipe_note: nil)
			puts "This note was removed from your recipe: '#{recipe_title}'"
			puts ""
		elsif RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note == nil
			puts "There is no note to remove from this recipe: '#{recipe_title}'"
			puts ""
		end
		self.modify_recipe_box(recipe_title)
	end

	def delete_recipe(recipe_title)
		puts "This recipe was deleted from your Recipe Box: '#{recipe_title}'"
		puts ""
		RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).destroy
		self.view_recipe_box
	end

	def load_recipe_url(recipe_title)
		url_array = Recipe.where(title: recipe_title).pluck(:source_url)
		url = url_array[0]
		system("open", "#{url}") 
	end
	
end