require 'minitest/spec'
require 'minitest/autorun'

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

  it "Creates the database file" do
    car.save
    File.exists?(Car::DATABASE_LOCATION).must_equal true
  end

  it "Check the current fields" do
    car.fields.must_equal [:year, :make, :model, :description, :price]
  end

  it "Check the current values" do
    car.values.must_equal [1997, 'Ford', 'E350', 'ac, abs, moon', 3000.00]
  end

  it "Check the current attributes" do
    expected_result = {:year=>1997, :make=>"Ford", :model=>"E350", :description=>"ac, abs, moon", :price=>3000.0}
    car.attributes.must_equal expected_result
  end
end