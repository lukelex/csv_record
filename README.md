# CsvRecord

[![Build Status](https://secure.travis-ci.org/lukasalexandre/csv_record.png)](http://travis-ci.org/lukasalexandre/csv_record) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/lukasalexandre/csv_record)

CSV Record connects Ruby classes to CSV documents database to establish an almost zero-configuration persistence layer for applications.

## Installation

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

## Usage

```ruby
require 'csv_record'

class Car
  include CsvRecord::Document

  attr_accessor :year, :make, :model, :description, :price
end
```

##Persistance
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

##Retrieving
Records can be queried through the following methds:

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

  has_many :cars

  attr_accessor :name
end

company = Company.create :name => 'Chutz'

car.company = company
car.save

company.cars # [#<Car:0x007f9b249b24d8>]
```

##Callbacks
Callbacks can be used to execute code on predetermined moments.

```ruby
before_create do |obj|
  obj.do_something
end

after_create do |obj|
  obj.do_something
end
```
`obj` refers to the instance you are in

##Validations

Helpers available:

`validates_presence_of`: Ensures if the specified attributes were filled

`validates_uniqueness_of`: Ensures that the specified attribute(s) are unique within the database

`validate`: Uses custom methods to validate the model

```ruby
class Company
  include CsvRecord::Document

  attr_accessor :name

  validates_presence_of :name
  validates_uniqueness_of :name

  validate :my_custom_validator_method

  def my_custom_validator_method
    @errors = self.errors.add attribute
  end
end

company = Company.create
company.save
# => false

company = Company.create
company.valid?
# => false
company.invalid?
# => true

```

##Precautions
CsvRecord creates a `db` folder in the root of your application. Be sure that it has permission to do so.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
