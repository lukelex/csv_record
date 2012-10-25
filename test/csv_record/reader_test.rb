require 'minitest/spec'
require 'minitest/autorun'
require 'csv'

require_relative '../models/car'

describe CsvRecord::Reader do
  describe 'initializing class methods' do
    it ('responds to fields') { Car.must_respond_to :fields }
    it ('responds to all') { Car.must_respond_to :all }
  end

  describe 'initializing instance methods' do
    it ('responds to values') { Car.new.must_respond_to :values }
    it ('responds to attributes') { Car.new.must_respond_to :attributes }
  end

  describe 'validating the methods behavior' do
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

    it "Retrieves the amount of registries" do
      car.save
      Car.all.size.must_equal 1
      second_car.save
      Car.all.size.must_equal 2
    end
  end
end