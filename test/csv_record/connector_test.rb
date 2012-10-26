require_relative '../test_helper'

require_relative '../models/car'

describe CsvRecord::Connector do
  describe 'initializing methods' do
    it ('responds to initialize_db_directory') { Car.must_respond_to :initialize_db_directory }
    it ('responds to initialize_db') { Car.must_respond_to :initialize_db }
    it ('responds to db_initialized?') { Car.must_respond_to :db_initialized? }
    it ('responds to open_database_file') { Car.must_respond_to :open_database_file }
  end

  describe 'validating the methods behavior' do
    after :each do
      FileUtils.rm_rf 'db'
    end

    let(:car) do
      Car.new(
        year: 1997,
        make: 'Ford',
        model: 'E350',
        description: 'ac, abs, moon',
        price: 3000.00
      )
    end

    it "Creates the database folder" do
      Car.initialize_db_directory.wont_be_nil
      Dir.exists?('db').must_equal true
    end

    it "Checks the database initialization state" do
      Car.db_initialized?.must_equal false
      car.save
      Car.db_initialized?.must_equal true
    end

    it "Creates the database file" do
      car.save
      File.exists?(Car::DATABASE_LOCATION).must_equal true
    end
  end
end