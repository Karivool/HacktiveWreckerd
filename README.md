# HacktiveWreckerd
---
HacktiveWreckerd is a custom ORM, used to convert data between incompatiable types. In this case, it'll be working with SQL and Ruby.

## What Does HacktiveWreckerd Do?
---
- `all` : returns records in the DB related to the model in question.
- `find` : finds the model with the corresponding `id`.
- `insert` : adds a new row to the SQL table in question.
- `save` : save/update a row, based on existence of given `id`.
- `update` : updates a given row.
- `where` : returns only objects that match given params.

- `belongs_to` : builds a method with the given association name and options.
- `has_many` : reverse of `belongs_to`.
- `has_one_through` : creates a join query using `table_name`, `foreign_key`, and `primary_key`.

## How Do I Use HacktiveWreckerd?
---
Clone or download this repo. Replace `lib/db_connection.rb` with different fields as necessary (in this case, anything related to pizza/PIZZA).

Afterwards, make your own Rails model and require `sql_object` and `assoc_options` within:

```ruby
#model.rb

require_relative "../lib/sql_object"
require_relative '../lib/assoc_options'

class Pizza > SQLObject
  #code here
end
```

Then, go into irb/pry, and load the file to try out HacktiveWreckerd's methods, or use them wherever you included them in your Rails project.

```ruby
#pizza.rb (Assumes model name is Pizza)

Pizza.all
# Returns all results for the db linked to the pizza model

Pizza.find(1)
# Finds the pizza model in question with the ID of 1

Pizza.save # "pizza_name" => "Peppertony", "eater_id" => 3
# Performs either .insert or .update, based on whether or not an id exists for the given SQL object.
# .insert will create a new row in your db, while .update makes changes to an existing one

Pizza.where(eater_id: 3)
# This will find all associated db objects that have the eater_id of 3. 
# This would return the pizza with the name, 'Peppertony'

```

You can also use methods to create associations between different models.

```ruby
class Pizza < SQLObject
  belongs_to: eater

end

class Eater < SQLObject
  has_many: pizzas

end

class Diner < SQLObject
  has_one_through: :diner, :eater
 
end

```
