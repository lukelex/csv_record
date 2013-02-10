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

And inside your Ruby models just require and include the CSV_Record lib and start using it in the same way as your are used to:

```ruby
require 'csv_record'

class Car
  include CsvRecord::Document

  attr_accessor :year, :make, :model, :description, :price
end
```

##Persistance
To persist the data objects created in your application your can use the following methods:

```ruby
Car.create( # save the new record in the database
  year: 2007,
  make: 'Chevrolet',
  model: 'F450',
  description: 'ac, abs, moon',
  price: 5000.00
)

car.save # save the record in the database (either creating or changing)

car.update_attribute :year, 1999 # update a single field of an object
car.update_attributes year: 1999, model: 'E762' # update multiple fields at the same time

car.destroy # removes the record from the database

car.new_record? # checks if the record is new
```

##Querying
Records can be queried through the following methods:

```ruby
Car.all # retrieves all saved records

Car.find car.id # find through its id
Car.find car # find through the record

Car.find_by_model 'F450' # find dynamically with a property
Car.find_by_model_and_price 'F450', 5000.00 # find dynamically with multiple properties

Car.where year: 2007, make: 'Chevrolet', model: 'F450' # find with a multiple parameters hash

Car.count # returns the amount of records in the database

Car.first # retrieves the first record in the database
Car.last # retrieves the last record in the database
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
class Company
  include CsvRecord::Document

  attr_accessor :name
end

class Car
  include CsvRecord::Document

  belongs_to :company
end

company = Company.create :name => 'Chuts'

car = Car.new :model => 'F450'

car.company = company
# or
car.company_id = company.id

car.save

car.company # #<Company:0x007f9b249b24d8>
```

###Has Many
Extending the previous example, you can use the `has_many` method to establish the inverse relationship:

```ruby
class Company
  include CsvRecord::Document

  attr_accessor :name

  has_many :cars
end

company = Company.create :name => 'Chutz'

car.company = company
car.save

company.cars # [#<Car:0x007f9b249b24d8>]
```

###Has One
The same as has_many but limited to one associated record.

```ruby
class Company
  include CsvRecord::Document

  attr_accessor :name

  has_one :car
end

company = Company.create :name => 'Chutz'

car.save
company.car = car

company.car # #<Car:0x007f9b249b24d8>
```

##Callbacks
###Overview
Callbacks can be used to execute code on predetermined moments.

####Usage
```ruby
after_create do
  self.do_something
end
```
`self` refers to the instance you are in

###Avaiable Callbacks
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
class Company
  include CsvRecord::Document

  attr_accessor :name

  validates_presence_of :name
  validates_uniqueness_of :name

  validate :my_custom_validator_method

  validate do
    self.errors.add :attribute
  end

  def my_custom_validator_method
    self.errors.add :attribute
  end
end

company = Company.create
company.save # => false

company = Company.create
company.valid? # => false
company.invalid? # => true
```

##Customizations

Someday you will want to go "out of the rail" that we propose. Here is what you can do now:

###Changing the table_name
```ruby
store_as :wierd_table_name
```
###Changing the field column name
```ruby
mapping :name => :wierd_field
```

##Bug reports

If you discover a problem with CSV_Record, we would like to know about it. However, we ask that you please review these guidelines before submitting a bug report:

##Contributing

We hope that you will consider contributing to CSV_Record. Please read this short overview for some information about how to get started:

https://github.com/lukelex/csv_record/wiki/Contributing

You will usually want to write tests for your changes. To run the test suite, go into CSV_Record's top-level directory and run "bundle install" and "rake". For the tests to pass.

##Precautions
CsvRecord creates a `db` folder in the root of your application. Be sure that it has permission to do so.