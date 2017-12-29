require_relative '../test_helper'

describe CsvRecord::Connector do
  describe 'initializing methods' do
    it ('responds to initialize_db_directory') { Jedi.must_respond_to :initialize_db_directory }
    it ('responds to initialize_db') { Jedi.must_respond_to :initialize_db }
    it ('responds to db_initialized?') { Jedi.must_respond_to :db_initialized? }
    it ('responds to open_database_file') { Jedi.must_respond_to :open_database_file }
  end

  describe 'validating the methods behavior' do
    it "Creates the database folder" do
      Jedi.initialize_db_directory.wont_be_nil
      Dir.exist?('db').must_equal true
    end

    it "Checks the database initialization state" do
      Jedi.db_initialized?.must_equal false
      luke.save
      Jedi.db_initialized?.must_equal true
    end

    it "Creates the database file" do
      luke.save
      File.exist?(Jedi::DATABASE_LOCATION).must_equal true
    end
  end
end
