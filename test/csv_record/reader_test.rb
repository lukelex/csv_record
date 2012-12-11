require_relative '../test_helper'

require_relative '../models/car'
require_relative '../models/jedi'

describe CsvRecord::Reader do
  describe 'initializing class methods' do
    it ('responds to fields') { Car.must_respond_to :fields }
    it ('responds to all') { Car.must_respond_to :all }
  end

  describe 'initializing instance methods' do
    it ('responds to values') { Car.new.must_respond_to :values }
    it ('responds to attributes') { Car.new.must_respond_to :attributes }
    it ('responds to to_param') { Car.new.must_respond_to :to_param }
    it ('responds to ==') { Car.new.must_respond_to :== }
    it ('responds to !=') { Car.new.must_respond_to :!= }
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

    it 'building an instance' do
      new_car = Car.build(
        year: 2007,
        make: 'Chevrolet',
        model: 'F450',
        description: 'ac, abs, moon',
        price: 5000.00
      )
      new_car.wont_be_nil
      new_car.must_be_instance_of Car
    end

    it "Check the current fields" do
      Car.fields.must_equal [:id, :created_at, :updated_at, :year, :make, :model, :description, :price]
    end

    it "Check the current values" do
      car.values.must_equal [nil, nil, nil, 1997, 'Ford', 'E350', 'ac, abs, moon', 3000.00]
    end

    it "Check the current attributes" do
      expected_result = {id: nil, created_at: nil, updated_at: nil, year: 1997, make: 'Ford', model: 'E350', description: 'ac, abs, moon', price: 3000.0}
      car.attributes.must_equal expected_result
    end

    it "Retrieves all registries" do
      car.save
      Car.all.size.must_equal 1
      second_car.save
      Car.all.size.must_equal 2
    end

    it "counting the registries" do
      car.save
      Car.count.must_equal 1
      second_car.save
      Car.count.must_equal 2
    end

    it 'checking to_param' do
      car.save
      car.to_param.wont_be_nil
      car.to_param.must_equal '1'
    end

    describe '==' do
      before do
        yoda.save
        luke.save
        jedi_council.save
      end

      it 'comparing with the same registry' do
        (yoda == yoda).must_equal true
      end

      it 'comparing with a diferent registry' do
        (yoda == luke).must_equal false
      end

      it 'comparing with another class registry' do
        (yoda == jedi_council).must_equal false
      end
    end

    describe '!=' do
      before do
        yoda.save
        luke.save
        jedi_council.save
      end

      it 'comparing with the same registry' do
        (yoda != yoda).must_equal false
      end

      it 'comparing with a diferent registry' do
        (yoda != luke).must_equal true
      end

      it 'comparing with another class registry' do
        (yoda != jedi_council).must_equal true
      end
    end

    describe 'simple query' do
      let (:cars) { [] }

      before do
        3.times do
          cars << car.clone
          cars.last.save
        end
      end

      it 'querying by id' do
        Car.find(cars.first.id).wont_be_nil
        Car.find(cars.first.id).must_be_instance_of Car
      end

      it 'querying by object' do
        Car.find(cars.first).wont_be_nil
        Car.find(cars.first.id).must_be_instance_of Car
      end

      it 'gets the first' do
        first_car = Car.first
        first_car.wont_be_nil
        first_car.must_be_instance_of Car
      end

      it 'gets the last' do
        last_car = Car.last
        last_car.wont_be_nil
        last_car.must_be_instance_of Car
      end
    end

    describe 'complex queries' do
      before do
        car.save
        second_car.save
      end

      it 'with a single parameter' do
        result = Car.where year: 2007
        result.wont_be_empty
        result.first.year.must_equal '2007'
      end

      it 'with multiple parameters' do
        result = Car.where year: 2007, make: 'Chevrolet', model: 'F450'
        result.wont_be_empty
        result.first.year.must_equal '2007'
      end

      it 'with invalid parameter' do
        result = Car.where year: 2008, make: 'Chevroletion'
        result.must_be_empty
      end
    end

    describe 'dynamic finders' do
      before do
        car.save
        second_car.save
      end

      let (:properties) { Car.fields }

      it 'respond to certain dynamic methods' do
        Car.must_respond_to "find_by_#{properties.sample}"
      end

      it 'finding with a single field' do
        found_cars = Car.find_by_year 2007
        found_cars.wont_be_empty
        found_cars.first.must_be_instance_of Car
      end

      it 'finding with multiple fields' do
        conditions = []
        properties.each_with_index do |property, i|
          values = []
          i.times do |k|
            conditions[i] = conditions[i] ? "#{conditions[i]}_and_#{properties[k]}" : properties[k]
            values << car.send(properties[k])
          end
          if conditions[i]
            found_cars = Car.public_send "find_by_#{conditions[i]}", *values
            found_cars.wont_be_empty
            found_cars.first.must_be_instance_of Car
          end
        end
      end
    end
  end
end