## NAME
Seriously Eat, Recipe Manager


## DESCRIPTION
This app pulled API content from Spoonacular.
Users can (via prompt) create a user id and/or log in through an existing id.
They can browse recipes & save recipes to their personal recipe box.
They can peruse existing recipes in their personal recipe box.
They can also update (add notes to) and/or remove recipes from their personal recipe box.


## AUTHORS
Roman Tetelbaum and Shelby Talbert


## ACKNOWLEDGEMENTS
As noted above, all API content was sourced through Spoonacular. https://spoonacular.com/food-api

Thanks to Jesus Castello of Ruby Guides for his guidance on Active Record searching for partial matches: .where("title LIKE ?", "%" + search_term + "%")
https://www.rubyguides.com/

Big thanks to Jim O'Neal for .pluck -- http://jamesponeal.github.io/projects/active-record-sheet.html

Thanks to Dwayne H Flatiron Technical Coach, we went back to Learn.co Jukebox Lab from pre-work to set up our numbered menus.

## LICENSE
MIT License

Copyright (c) [2020] [Seriously Eat, Recipe Manager]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
