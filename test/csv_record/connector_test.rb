require 'minitest/spec'
require 'minitest/autorun'

require_relative '../models/car'

describe CsvRecord::Connector do
  describe 'initializing methods' do
    it ('responds to initialize_db_directory') { Car.must_respond_to :initialize_db_directory }
    it ('responds to initialize_db') { Car.must_respond_to :initialize_db }
    it ('responds to db_initialized?') { Car.must_respond_to :db_initialized? }
    it ('responds to open_database_file') { Car.must_respond_to :open_database_file }
  end
end