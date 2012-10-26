require 'minitest/spec'
require 'minitest/autorun'

require 'timecop'

require_relative '../models/car'

describe CsvRecord::Timestamps do
  describe 'initializing instance methods' do
    let (:car) { Car.new }

    it ('respond to created_at') { car.must_respond_to :created_at }
    it ('respond to set_creation_time') { car.must_respond_to :set_creation_time }
  end

  describe 'setting its values' do
    let(:car) do
      Car.new(
        year: 1997,
        make: 'Ford',
        model: 'E350',
        description: 'ac, abs, moon',
        price: 3000.00
      )
    end

    before do
      Timecop.freeze(Time.new)
    end

    after do
      Timecop.return
      FileUtils.rm_rf 'db'
    end

    it 'sets the time wich the object was created' do
      car.save
      car.created_at.must_equal Time.new
    end

    it 'sets the time wich the object was created' do
      car.save
      car.created_at.must_equal Time.new
    end
  end
end