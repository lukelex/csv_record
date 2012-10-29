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

  describe 'defines on create' do
    before do
      Timecop.freeze(Time.now.utc)
    end

    after do
      Timecop.return
    end

    it 'sets the time wich the object was created' do
      car.save
      car.created_at.must_equal Time.now.utc
    end

    it 'sets the updated time on created' do
      car.save
      car.updated_at.must_equal Time.now.utc
    end
  end

  describe 'update on update' do
    it 'sets the updated_at attribute on every save' do
      car.save
      previous_time = car.updated_at
      car.update_attribute :year, '1800'
      car.updated_at.wont_equal previous_time
    end
  end
end