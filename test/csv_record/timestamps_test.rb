require_relative '../test_helper'

require 'timecop'

require_relative '../models/car'

describe CsvRecord::Timestamps do
  describe 'initializing instance methods' do
    it ('responds to created_at') { car.must_respond_to :created_at }
    it ('responds to set_created_at') { car.must_respond_to :set_created_at }
  end

  describe 'checking if it`s extracting the right fields' do
    it ('checking created_at') { Car.fields.must_include :created_at }
  end

  describe 'setting its values' do
    before do
      Timecop.freeze(Time.new)
    end

    after do
      Timecop.return
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