require_relative '../test_helper'

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
      Car.fields.must_equal [:id, :created_at, :updated_at, :year, :make, :model, :description, :price]
    end

    it "Check the current values" do
      car.values.must_equal [nil, nil, nil, 1997, 'Ford', 'E350', 'ac, abs, moon', 3000.00]
    end

    it "Check the current attributes" do
      expected_result = {:id=>nil, :created_at=>nil, :updated_at=>nil, :year=>1997, :make=>"Ford", :model=>"E350", :description=>"ac, abs, moon", :price=>3000.0}
      car.attributes.must_equal expected_result
    end

    it "Retrieves all registries" do
      car.save
      Car.all.size.must_equal 1
      second_car.save
      Car.all.size.must_equal 2
    end

    it "Retrieves all registries" do
      car.save
      Car.count.must_equal 1
      second_car.save
      Car.count.must_equal 2
    end

    it 'querying by id' do
      cars = []
      3.times do
        cars << car.clone
        cars.last.save
      end
      Car.find(cars.first.id).wont_be_nil
      Car.find(cars.first.id).must_be_instance_of Car
    end

    it 'querying by object' do
      cars = []
      3.times do
        cars << car.clone
        cars.last.save
      end
      Car.find(cars.first).wont_be_nil
      Car.find(cars.first.id).must_be_instance_of Car
    end
  end
end