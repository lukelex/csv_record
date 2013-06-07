# CsvRecord

[![Build Status](https://travis-ci.org/lukelex/csv_record.png?branch=2.0.0)](https://travis-ci.org/lukelex/csv_record) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/lukelex/csv_record) [![Dependency Status](https://gemnasium.com/lukasalexandre/csv_record.png)](https://gemnasium.com/lukasalexandre/csv_record) [![Gem Version](https://fury-badge.herokuapp.com/rb/csv_record.png)](http://badge.fury.io/rb/csv_record)

CSV Record connects Ruby classes to CSV documents database to establish an almost zero-configuration persistence layer for applications.

##Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'csv_record'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install csv_record
```

And inside your Ruby models just require and include the CSVRecord lib and start using it in the same way as your are used to:

```ruby
require 'csv_record'

class Jedi
  include CsvRecord::Document

  attr_accessor :name, :age, :midi_chlorians
end
```

##Persistence
To persist the data objects created in your application you can use the following methods:

```ruby
Jedi.create( # save the new record in the database
  name: 'Luke Skywalker',
  age: 18,
  midi_chlorians: '12k'
)

jedi.save # save the record in the database (either creating or changing)

jedi.update_attribute :age, 29 # update a single field of an object
jedi.update_attributes age: 29, midi_chlorians: '18k' # update multiple fields at the same time

jedi.destroy # removes the record from the database

jedi.new_record? # checks if the record is new
```

##Querying
Records can be queried through the following methods:

```ruby
Jedi.all # retrieves all saved records

Jedi.find jedi.id # find through its id
Jedi.find jedi # find through the record

Jedi.find_by_age 18 # find dynamically with a property
Jedi.find_by_name_and_age 'Luke Skywalker', 18 # find dynamically with multiple properties

Jedi.where age: 18, name: 'Luke Skywalker', midi_chlorians: '12k' # find with a multiple parameters hash

Jedi.count # returns the amount of records in the database

Jedi.first # retrieves the first record in the database
Jedi.last # retrieves the last record in the database
```

Lazy querying is the default behavior now Yey!!

```ruby
query = Jedi.where(age: 37).where(midi_chlorians: '4k')
query # #<CsvRecord::Query:0x007fdff3d31aa0>

query.first # #<Jedi:0x007f9df6cea478>
```

##Associations
###Belongs To
A Belongs To association can be declared through the following method:

```ruby
class JediOrder
  include CsvRecord::Document

  attr_accessor :rank
end

class Jedi
  include CsvRecord::Document

  belongs_to :jedi_order

  attr_accessor :name
end

jedi_order = JediOrder.create rank: 'council'

jedi = Jedi.new name: 'Lukas Alexandre'

jedi.jedi_order = jedi_order
# or
jedi.jedi_order_id = jedi_order.id

jedi.save

jedi.jedi_order # #<JediOrder:0x007f9b249b24d8>
```

###Has Many
Extending the previous example, you can use the `has_many` method to establish the inverse relationship:

```ruby
class JediOrder
  include CsvRecord::Document

  attr_accessor :rank

  has_many :jedis
end

jedi_order = JediOrder.create rank: 'council'

jedi.jedi_order = jedi_order
jedi.save

jedi_order.jedis # [#<Jedi:0x007f9b249b24d8>]
```

###Has One
The same as has_many but limited to one associated record.

```ruby
class jedi
  include CsvRecord::Document

  attr_accessor :name

  has_one :padawan
end

class Padawan
  include CsvRecord::Document

  attr_accessor :name

  belongs_to :jedi
end

padawan = Padawan.create name: 'Lukas Alexandre'

jedi.padawan = padawan

jedi.padawan # #<Padawan:0x007f9b249b24d8>
```

##Callbacks
###Overview
Callbacks can be used to execute code on predetermined moments.

####Usage
```ruby
after_create do
  # learn the way of the force
end
```
`self` refers to the instance you are in

###Available Callbacks
Here is a list with all the available callbacks, listed in the same order in which they will get called during the respective operations:

####Finding an Object
* after_initialize
* after_find

####Creating an Object
* after_initialize
* before_validation
* after_validation
* before_save
* before_create
* after_create
* after_save

####Updating an Object
* before_validation
* after_validation
* before_save
* before_update
* after_update
* after_save

####Destroying an Object
* before_destroy
* after_destroy

##Validations
###Helpers available:

`validates_presence_of`: Ensures if the specified attribute(s) were filled

`validates_uniqueness_of`: Ensures that the specified attribute(s) are unique within the database

`validate`: Uses custom method(s) to validate the model

```ruby
class Jedi
  include CsvRecord::Document

  attr_accessor :name

  validates_presence_of :name
  validates_uniqueness_of :name

  validate :my_custom_validator_method

  validate do
    self.errors.add :attribute if self.using_dark_force?
  end

  def my_custom_validator_method
    self.errors.add :attribute if self.attacking_instead_of_defending?
  end
end

jedi = Jedi.new

jedi.valid? # => false
jedi.invalid? # => true
jedi.save # => false
```

##Customizations

Someday you might want to go "out of the rail" that we propose. Here is what you can do now:

###Changing the table_name
```ruby
store_as :wierd_table_name
```
###Changing the field column name
```ruby
mapping :name => :wierd_field
```

##Bug reports

If you discover a problem with CSV_Record, we would like to know about it. Please let us know on the project issues page.

##Contributing

We hope that you will consider contributing to CSV_Record. Please read this short overview for some information about how to get started:

https://github.com/lukelex/csv_record/wiki/Contributing

You will usually want to write tests for your changes. To run the test suite, go into CSV_Record's top-level directory and run "bundle install" and "rake". For the tests to pass.

##Precautions
CsvRecord creates a `db` folder in the root of your application. Be sure that it has permission to do so.
