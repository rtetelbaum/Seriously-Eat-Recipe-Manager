class CLI 

    def welcome
        puts "Welcome to Seriously, Eat! Where seriously, we want you to eat."
        puts "What's your name?"
        name = gets.chomp
        User.create(name: name)

        self.menu 
        binding.pry 
    end

    def menu
        puts "Choose an option!"
        puts "1. Browse All Recipes"
        puts "2. Save A Recipe"
        puts "3. Heart A Recipe"
        puts "4. Leave Notes To Self (Regarding a Recipe)"
		puts "5. View Your Recipe Box"
		puts "6. View Hearted Recipes"
        puts "7. Remove A Recipe From Your Recipe Box"
        puts "8. Exit"
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