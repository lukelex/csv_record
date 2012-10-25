require 'minitest/spec'
require 'minitest/autorun'
require 'csv_record'

require_relative '../models/car'

describe CsvRecord do
  describe "save" do
    after :each do
      # FileUtils.rm_rf fetch_fixture_path('db')
    end
  end
end