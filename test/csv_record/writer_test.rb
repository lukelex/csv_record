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
    it 'responds to save' do
      Car.new.must_respond_to :save
    end
  end
end