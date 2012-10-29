# CsvRecord

CSV Record connects classes to CSV documents database to establish an almost zero-configuration persistence layer for applications.

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
class Car
  include CsvRecord::Document
end
```

By including this module you will gain for free the following methods:

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

car.destroy # removes the record from the database

car.new_record? # checks if the record is new

Class.all # retrieves all saved records

Class.find car.id # find through its id
Class.find car # find through the record

Car.count # returns the amount of records in the database
```

##Precautions
CsvRecord creates a `db` folder in the root of your application. Be sure that it has permission to do so.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
