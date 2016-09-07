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

After, make your own model and require `sql_object` and `assoc_options`:

```ruby
#model.rb

require_relative "../lib/sql_object"
require_relative '../lib/assoc_options'

class Pizza > SQLObject
  #code here
end
```

Afterwards, go into irb/pry, and load the file to use HacktiveWreckerd's methods.
