# CsvRecord

[![Build Status](https://secure.travis-ci.org/lukasalexandre/csv_record.png)](http://travis-ci.org/lukasalexandre/csv_record) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/lukasalexandre/csv_record)

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
requite 'csv_record'

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

Car.all # retrieves all saved records

Car.find car.id # find through its id
Car.find car # find through the record

Car.count # returns the amount of records in the database

Car.first # retrieves the first record in the database
Car.last # retrieves the last record in the database
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

##Precautions
CsvRecord creates a `db` folder in the root of your application. Be sure that it has permission to do so.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
