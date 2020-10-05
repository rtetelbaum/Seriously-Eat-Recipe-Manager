## NAME
Seriously, Eat! Recipe Manager


## INSTALL INSTRUCTIONS
To start program run 'ruby bin/start' in your terminal


## DESCRIPTION
This app pulled API content from **Spoonacular**.
Users can (via prompt) create a user id and/or log in through an existing id.
They can browse recipes & save recipes to their personal recipe box.
They can navigate to and peruse existing recipes in their personal recipe box.
They can also update (add notes to) and/or remove recipes from their personal recipe box.


## AUTHORS
Roman Tetelbaum and Shelby Talbert


## ACKNOWLEDGEMENTS
As noted above, all API content was sourced through [Spoonacular](https://spoonacular.com/food-api)

Thanks to Jesus Castello of [Ruby Guides](https://www.rubyguides.com/) for his guidance on Active Record searching for partial matches: .where("title LIKE ?", "%" + search_term + "%")

Thanks to Dwayne H Flatiron Technical Coach: we went back to Learn.co Jukebox Lab from pre-work to set up our numbered menus.

Big thanks to [Jim O'Neal](http://jamesponeal.github.io/projects/active-record-sheet.html) for .pluck