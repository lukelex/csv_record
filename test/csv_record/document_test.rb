require 'minitest/spec'
require 'minitest/autorun'
require 'csv'

require_relative '../models/car'

describe CsvRecord::Document do
  after :each do
    FileUtils.rm_rf 'db'
  end

  let(:car) do
    Car.new(
      year: 1997,
      make: 'Ford',
      model: 'E350',
      description: 'ac, abs, moon',
      price: 3000.00
    )
  end

  let(:second_car) do
    Car.new(
      year: 2007,
      make: 'Chevrolet',
      model: 'F450',
      description: 'ac, abs, moon',
      price: 5000.00
    )
  end

  it "Creates the database folder" do
    Car.initialize_db_directory.wont_be_nil
    Dir.exists?('db').must_equal true
  end

  it "Check the current fields" do
    Car.fields.must_equal [:year, :make, :model, :description, :price]
  end

  it "Check the current values" do
    car.values.must_equal [1997, 'Ford', 'E350', 'ac, abs, moon', 3000.00]
  end

  it "Check the current attributes" do
    expected_result = {:year=>1997, :make=>"Ford", :model=>"E350", :description=>"ac, abs, moon", :price=>3000.0}
    car.attributes.must_equal expected_result
  end

  it "Creates the database file" do
    car.save
    File.exists?(Car::DATABASE_LOCATION).must_equal true
  end

  it "Checks the database initialization state" do
    Car.db_initialized?.must_equal false
    car.save
    Car.db_initialized?.must_equal true
  end

  it "Creates more than one registry" do
    car.save
    second_car.save
    CSV.open(Car::DATABASE_LOCATION, 'r', :headers => true) do |csv|
      csv.entries.size.must_equal 2
    end
  end

  it "Retrieves the amount of registries" do
    car.save
    Car.all.size.must_equal 1
    second_car.save
    Car.all.size.must_equal 2
  end

  it "Sets the ID of the created object" do
    car.id.must_be_nil
    car.save
    car.id.must_equal 1
    second_car.save
    second_car.id.must_equal 2
  end

  it "Creates the object through create method" do
    created_car = Car.create(
      year: 2007,
      make: 'Chevrolet',
      model: 'F450',
      description: 'ac, abs, moon',
      price: 5000.00
    )
    created_car.wont_be_nil
    created_car.must_be_instance_of Car
  end
end