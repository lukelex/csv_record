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
    it ('responds to update_attributes') { car.must_respond_to :update_attributes }
    it ('responds to destroy') { car.must_respond_to :destroy }
  end

  describe 'validating the methods behavior' do
    let(:second_car) do
      Car.build(
        year: 2007,
        make: 'Chevrolet',
        model: 'F450',
        description: 'ac, abs, moon',
        price: 5000.00
      )
    end

    describe 'create' do
      it "Creates more than one registry" do
        car.save
        second_car.save
        Car.all.size.must_equal 2
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
    end

    describe 'new_record' do
      it "Checks whether is a new record" do
        car.new_record?.must_equal true
        car.save
        car.new_record?.must_equal false
      end

      it "Checks whether a previously saved record is a new record" do
        car.save
        Car.find(car).new_record?.must_equal false
      end
    end

    describe 'updates' do
      it "Updates a single field" do
        car.save
        car.update_attribute :year, 2008
        Car.find(car).year.must_equal '2008'
      end

      it "Updates multiple fields at the same time" do
        car.save
        car.update_attributes year: 2008, model: 'E846'
        Car.find(car).year.must_equal '2008'
        Car.find(car).model.must_equal 'E846'
      end

      it "Updates multiple fields using save" do
        car.save
        car.year = 2008
        car.model = 'E846'
        car.save
        retrieved_car = Car.find(car)
        retrieved_car.year.must_equal '2008'
        retrieved_car.model.must_equal 'E846'
      end
    end

    describe 'destroy' do
      it 'remove the object from the database' do
        car.save
        car.destroy
        Car.count.must_equal 0
      end

      it 'by destroying the object its timestamps and id should be empty' do
        car.save
        car.destroy
        car.id.must_be_nil
        car.created_at.must_be_nil
        car.updated_at.must_be_nil
      end
    end
  end
end