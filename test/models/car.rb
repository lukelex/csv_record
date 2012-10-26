require 'csv_record'

class Car
  include CsvRecord::Document

  def initialize(params={})
    params.each do |key, value|
      self.public_send("#{key}=", value)
    end
  end

  attr_accessor :year, :make, :model, :description, :price
end