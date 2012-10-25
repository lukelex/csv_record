require 'minitest/spec'
require 'minitest/autorun'
require 'csv'

require_relative '../models/car'

describe CsvRecord::Writer do
  describe 'initializing class methods' do
    it 'responds to create' do
      Car.must_respond_to :create
    end
  end

  describe 'initializing instance methods' do
    it ('responds to save') { Car.new.must_respond_to :save }
    it ('responds to new_record?') { Car.new.must_respond_to :new_record? }
    it ('responds to calculate_id') { Car.new.must_respond_to :calculate_id }
    it ('responds to write_object') { Car.new.must_respond_to :write_object }
  end
end