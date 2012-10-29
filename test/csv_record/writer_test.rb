require_relative '../test_helper'

require_relative '../models/car'

describe CsvRecord::Writer do
  describe 'initializing class methods' do
    it 'responds to create' do
      Car.must_respond_to :create
    end
  end

  describe 'initializing instance methods' do
    it ('responds to save') { car.must_respond_to :save }
    it ('responds to new_record?') { car.must_respond_to :new_record? }
    it ('responds to calculate_id') { car.must_respond_to :calculate_id }
    it ('responds to write_object') { car.must_respond_to :write_object }
    it ('responds to id') { car.must_respond_to :id }
    it ('responds to update_attribute') { car.must_respond_to :update_attribute }
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

    it "Creates more than one registry" do
      car.save
      second_car.save
      Car.all.size.must_equal 2
    end

    it "Checks whether is a new record" do
      car.new_record?.must_equal true
      car.save
      car.new_record?.must_equal false
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
      created_car.new_record?.must_equal false
    end

    it "Sets the ID of the created object" do
      car.id.must_be_nil
      car.save
      car.id.must_equal 1
      second_car.save
      second_car.id.must_equal 2
    end

    it "Updates a single field" do
      car.save
      car.update_attribute :year, 2008
      Car.find(car).year.must_equal '2008'
    end
  end
end