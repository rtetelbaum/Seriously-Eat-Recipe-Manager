require_relative '../config/environment.rb'

class CLI

	attr_accessor :current_user, :pastel

	$pastel = Pastel.new(eachline: "\n")

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
		puts $pastel.bright_magenta.on_blue.bold("Do you have a 'Seriously, Eat!' account? (y/n)")
		puts ""
		choice = gets.chomp
		puts""
		if choice == "y"
			puts $pastel.bright_magenta.on_blue.bold("Please enter your username:")
			puts ""
			username = gets.chomp
			puts""
			if User.find_by(user_name: username)
				@current_user = User.find_by(user_name: username)
				self.options
			else
				puts $pastel.bright_magenta.on_blue.bold("This username does not exist. Would you like create an account? (y/n)")
				puts ""
				choice = gets.chomp
				puts ""
				self.account_option(choice)
			end
		elsif choice == "n"
			puts $pastel.bright_magenta.on_blue.bold("Would you like create an account? (y/n)")
				puts ""
				choice = gets.chomp
				puts ""
				self.account_option(choice)
		end
	end

	def account_option(choice)
		if choice == "y"
			self.create_new_user
			self.options
		elsif choice == "n"
			puts $pastel.bright_magenta.on_blue.bold("Goodbye!")
			puts ""
		end
	end

	def create_new_user
		puts $pastel.bright_magenta.on_blue.bold("Please enter a new username:")
		puts "" 
		new_username = gets.chomp
		puts ""
		@current_user = User.create(user_name: new_username)
		puts $pastel.bright_magenta.on_blue.bold("Welcome, #{new_username}. We hope you're hungry!")
		puts ""
	end

	def options
		puts $pastel.bright_magenta.on_blue.bold("OPTIONS MENU")
		puts $pastel.bright_magenta("Enter an option number:")
		puts $pastel.bright_magenta("1. Browse recipes")
		puts $pastel.bright_magenta("2. View your Recipe Box (saved recipes)")
		puts $pastel.bright_magenta("3. Exit")
		puts ""
		choice = gets.chomp
			if choice == "1" || choice == "1."
				puts ""
				self.browse_recipes
			elsif choice == "2" || choice == "2."
				puts ""
				self.view_recipe_box
			elsif choice == "3" || choice == "3."
				puts ""
				puts $pastel.bright_magenta.on_blue.bold("Goodbye!")
				puts ""
				exit
			end
	end

	def browse_recipes
		puts $pastel.bright_magenta.on_blue.bold("BROWSE RECIPES")
		puts $pastel.bright_magenta("How would you like to search? (choose number)")
		puts $pastel.bright_magenta("1. Search by recipe name")
		puts $pastel.bright_magenta("2. View popular recipes")
		puts $pastel.bright_magenta("3. View healthy recipes")
		puts $pastel.bright_magenta("4. View vegetarian recipes")
		puts $pastel.bright_magenta("5. Return to Options Menu")
		puts ""
		choice = gets.chomp
			if choice == "1" || choice == "1."
				puts ""
				self.search_by_name
			elsif choice == "2" || choice == "2."
				puts ""
				self.search_by_popular
			elsif choice == "3" || choice == "3."
				puts ""
				self.search_by_healthy
			elsif choice == "4" || choice == "4."
				puts ""
				self.search_by_vegetarian
			elsif choice == "5" || choice == "5."
				puts ""
				self.options
			end
	end

	def recipe_options(recipe_title)
		puts $pastel.bright_magenta.on_blue.bold("RECIPE OPTIONS")
		puts ""
		puts $pastel.bright_magenta("The recipe you've selected is: '#{recipe_title}'")
		puts ""
		puts $pastel.bright_magenta("Enter an option number:")
		puts $pastel.bright_magenta("1. View website for this recipe")
		puts $pastel.bright_magenta("2. Save recipe to Recipe Box")
		puts $pastel.bright_magenta("3. Go back to Browse Recipes")
		puts ""
		choice = gets.chomp
		puts ""
		if choice == "1" || choice == "1."
			self.load_recipe_url(recipe_title)
			self.recipe_options(recipe_title)
		elsif choice == "2" || choice == "2."
			current_recipe = Recipe.find_by(title: recipe_title)
			RecipeBox.create(user_id: @current_user.id, recipe_id: current_recipe.id)
			puts $pastel.bright_magenta("Your recipe '#{recipe_title}' has been savedto your Recipe Box.")
			self.recipe_options(recipe_title)
		elsif choice == "3" || choice == "3."
			self.browse_recipes
		end
	end

	def search_by_name
		puts $pastel.bright_magenta.on_blue.bold("SEARCH RECIPES BY NAME")
		puts $pastel.bright_magenta("Please enter a search term:")
		puts ""
		search_term = gets.chomp
		puts ""
		results = Recipe.where("title LIKE ?", "%" + search_term + "%").pluck(:title)
			until !results.empty?
				puts $pastel.bright_magenta("No matching results, please try again:")
				puts ""
				search_term = gets.chomp
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
		puts $pastel.bright_magenta("Results:")
		results.each_with_index { |r, i| puts $pastel.bright_magenta("#{i.next}. #{r}") }
		puts ""
		puts $pastel.bright_magenta("Please enter a recipe number or type 'exit' to return to Browse Recipes:")
		puts ""        
		choice = gets.chomp
		puts ""
		self.browse_recipes if choice == "exit"
		index = choice.to_i - 1
		recipe_title = results[index]
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
				results.each_with_index { |r, i| puts $pastel.bright_magenta("#{i.next}. #{Recipe.find(r.recipe_id).title}")}
				puts ""
				puts $pastel.bright_magenta("Please enter a recipe number to see it, view/add a note to it, or delete it from your Recipe Box:")
				puts $pastel.bright_magenta("(Or type 'exit' to return to the Options Menu)")
				puts ""
				choice = gets.chomp
				puts ""
				self.options if choice == "exit"
				index = choice.to_i - 1
				recipe_title = Recipe.find(results[index].recipe_id).title
				modify_recipe_box(recipe_title)
			end
	end

	def modify_recipe_box(recipe_title)
		puts $pastel.bright_magenta.on_blue.bold("SAVED RECIPE OPTIONS")
		puts $pastel.bright_magenta("The saved recipe you've selected is: '#{recipe_title}'")
		puts $pastel.bright_magenta("Enter an option number:")
		puts $pastel.bright_magenta("1. Open website for this recipe")
		puts $pastel.bright_magenta("2. View your note for this recipe")
		puts $pastel.bright_magenta("3. Add/update note for this recipe")
		puts $pastel.bright_magenta("4. Remove note from this recipe")
		puts $pastel.bright_magenta("5. Delete this recipe from your Recipe Box")
		puts $pastel.bright_magenta("6. Go back to your Recipe Box")
		puts ""
		choice = gets.chomp
		puts ""
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
				self.delete_recipe(recipe_title)
			elsif choice == "6" || choice == "6."
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