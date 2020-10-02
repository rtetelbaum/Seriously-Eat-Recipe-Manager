require_relative '../../config/environment.rb'

class CLI

	attr_accessor :current_user, :pastel

	$pastel = Pastel.new(eachline: "\n")
	$prompt = TTY::Prompt.new

	def welcome
		font = TTY::Font.new(:standard)
		starvin = Sound.new('./starvin.wav')
		# puts $pastel.bright_magenta.bold(font.write("Welcome  to"))
		# sleep(1)
		# puts $pastel.bright_magenta.bold(font.write("Seriously,  Eat!"))
		# sleep(1)
		# puts $pastel.bright_magenta.bold(font.write("Where  seriously..."))
		# sleep(3)
		# puts $pastel.bright_magenta.bold(font.write("we  want  you  to  eat."))
		# starvin.play
		# sleep(4)
		puts ""
		choice = $prompt.yes?($pastel.bright_magenta.on_blue.bold("Do you have a 'Seriously, Eat!' account?"))
		puts ""
		if choice == true
			username = $prompt.ask($pastel.bright_magenta.on_blue.bold("Please enter your username:"))
			if User.find_by(user_name: username)
				@current_user = User.find_by(user_name: username)
				puts ""
				self.options
			else
				choice = $prompt.yes?($pastel.bright_magenta.on_blue.bold("This username does not exist. Would you like create an account?"))
				puts ""
				self.account_option(choice)
			end
		elsif choice == false
			choice = $prompt.yes?($pastel.bright_magenta.on_blue.bold("Would you like create an account?"))
				puts ""
				self.account_option(choice)
		end
	end

	def account_option(choice)
		if choice == true
			self.create_new_user
			self.options
		elsif choice == false
			puts $pastel.bright_magenta.on_blue.bold("Goodbye!")
			puts ""
		end
	end

	def create_new_user
		new_username = $prompt.ask($pastel.bright_magenta.on_blue.bold("Please enter a new username:"))
		puts "" 
		@current_user = User.create(user_name: new_username)
		puts $pastel.bright_magenta.on_blue.bold("Welcome, #{new_username}. We hope you're hungry!")
		puts ""
	end

	def options
		choice = $prompt.select($pastel.bright_magenta.on_blue.bold("OPTIONS MENU")) do |menu|
			menu.choice $pastel.bright_magenta("Browse recipes"), 1
			menu.choice $pastel.bright_magenta("View your Recipe Box (saved recipes)"), 2
			menu.choice $pastel.bright_magenta("Exit"), 3
		end
		puts ""
		if choice == 1
			self.browse_recipes
		elsif choice == 2
			self.view_recipe_box
		elsif choice == 3
			puts $pastel.bright_magenta.on_blue.bold("Goodbye!")
			puts ""
			exit
		end
	end

	def browse_recipes
		puts ""
		puts $pastel.bright_magenta.on_blue.bold("BROWSE RECIPES")
		choice = $prompt.select($pastel.bright_magenta("How would you like to search?")) do |menu|
		menu.choice $pastel.bright_magenta("Search by recipe name"), 1
		menu.choice $pastel.bright_magenta("View popular recipes"), 2
		menu.choice $pastel.bright_magenta("View healthy recipes"), 3
		menu.choice $pastel.bright_magenta("View vegetarian recipes"), 4
		menu.choice $pastel.bright_magenta("Return to Options Menu"), 5
		end
		puts ""
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
		puts $pastel.bright_magenta("The recipe you've selected is: '#{recipe_title}'")
		puts ""
		choice = $prompt.select($pastel.bright_magenta("Enter an option number:")) do |menu|
		menu.choice $pastel.bright_magenta("View website for this recipe"), 1
		menu.choice $pastel.bright_magenta("Save recipe to Recipe Box"), 2
		menu.choice $pastel.bright_magenta("Go back to Browse Recipes"), 3
		end
		puts ""
		if choice == 1
			self.load_recipe_url(recipe_title)
			self.recipe_options(recipe_title)
		elsif choice == 2
			current_recipe = Recipe.find_by(title: recipe_title)
			RecipeBox.create(user_id: @current_user.id, recipe_id: current_recipe.id)
			puts $pastel.bright_magenta("Your recipe '#{recipe_title}' has been saved to your Recipe Box.")
			puts ""
			self.recipe_options(recipe_title)
		elsif choice == 3
			self.browse_recipes
		end
	end

	def search_by_name
		puts $pastel.bright_magenta.on_blue.bold("SEARCH RECIPES BY NAME")
		search_term = $prompt.ask($pastel.bright_magenta("Please enter a search term:"))
		puts ""
		results = Recipe.where("title LIKE ?", "%" + search_term + "%").pluck(:title)
			until !results.empty?
				search_term = $prompt.ask($pastel.bright_magenta("No matching results, please try again:"))
				puts ""
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
		recipe_title = $prompt.select($pastel.bright_magenta("Select a recipe:")) do |menu|
			results.each { |r| menu.choice $pastel.bright_magenta("#{r}") }
			menu.choice $pastel.bright_magenta("Go back to Browse Recipes"), -> { self.browse_recipes }
		end
		puts ""
		self.recipe_options(recipe_title)
	end

	def view_recipe_box
		puts $pastel.bright_magenta.on_blue.bold("YOUR RECIPE BOX")
		results = RecipeBox.where(user_id: @current_user.id)
		if results.empty?
			puts $pastel.bright_magenta("Your Recipe Box is empty.")
			puts ""
			self.options
		elsif !results.empty?
			recipe_title = $prompt.select($pastel.bright_magenta("Select a recipe to see it, view/add a note to it, or delete it from your Recipe Box:")) do |menu|
				results.each { |r| menu.choice $pastel.bright_magenta("#{Recipe.find(r.recipe_id).title}") }
				menu.choice $pastel.bright_magenta("Go back to Browse Recipes"), -> { self.options }
			end
			puts ""
			modify_recipe_box(recipe_title)
		end
	end

	def modify_recipe_box(recipe_title)
		puts $pastel.bright_magenta.on_blue.bold("SAVED RECIPE OPTIONS")
		puts $pastel.bright_magenta("The saved recipe you've selected is: '#{recipe_title}'")
		choice = $prompt.select($pastel.bright_magenta("Enter an option number:")) do |menu|
			menu.choice $pastel.bright_magenta("Open website for this recipe"), 1
			menu.choice $pastel.bright_magenta("View your note for this recipe"), 2
			menu.choice $pastel.bright_magenta("Add/update note for this recipe"), 3
			menu.choice $pastel.bright_magenta("Remove note from this recipe"), 4
			menu.choice $pastel.bright_magenta("Delete this recipe from your Recipe Box"), 5
			menu.choice $pastel.bright_magenta("Go back to your Recipe Box"), 6
		end
		puts ""
			if choice == 1
				self.load_recipe_url(recipe_title)
				self.modify_recipe_box(recipe_title)
			elsif choice == 2
				self.view_recipe_note(recipe_title)
			elsif choice == 3
				self.add_note_to_recipe(recipe_title)
			elsif choice == 4
				self.remove_note_from_recipe(recipe_title)
			elsif choice == 5
				self.delete_recipe(recipe_title)
			elsif choice == 6
				self.view_recipe_box
			end
	end

	def view_recipe_note(recipe_title)
		if RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note != nil
			puts $pastel.bright_magenta("Your note for the recipe: '#{recipe_title}'")
			puts ""
			puts RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note
			puts ""
		elsif RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note == nil
			puts $pastel.bright_magenta("There is no note for this recipe: '#{recipe_title}'")
			puts ""
			self.modify_recipe_box(recipe_title)
		end
		self.modify_recipe_box(recipe_title)
	end

	def add_note_to_recipe(recipe_title)
		puts $pastel.bright_magenta.on_blue.bold("ADD/UPDATE NOTE FOR RECIPE")
		puts $pastel.bright_magenta("Recipe to add/update note for: '#{recipe_title}'")
		puts $pastel.bright_magenta("Please type the note you would like to add:")
		puts ""
		note = gets.chomp
		puts ""
		RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).update(recipe_note: note)
		puts $pastel.bright_magenta("Your note has been added for your recipe: '#{recipe_title}'")
		puts ""
		self.modify_recipe_box(recipe_title)
	end

	def remove_note_from_recipe(recipe_title)
		if RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note != nil
			RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).update(recipe_note: nil)
			puts $pastel.bright_magenta("This note was removed from your recipe: '#{recipe_title}'")
			puts ""
		elsif RecipeBox.find_by(user_id: @current_user.id, recipe_id: Recipe.find_by(title: recipe_title).id).recipe_note == nil
			puts $pastel.bright_magenta("There is no note to remove from this recipe: '#{recipe_title}'")
			puts ""
		end
		self.modify_recipe_box(recipe_title)
	end

	def delete_recipe(recipe_title)
		puts $pastel.bright_magenta("This recipe was deleted from your Recipe Box: '#{recipe_title}'")
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