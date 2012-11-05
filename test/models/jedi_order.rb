require 'csv_record'

class JediOrder
  include CsvRecord::Document

  def initialize(params={})
    params.each do |key, value|
      self.public_send("#{key}=", value)
    end
  end

  attr_accessor :rank
end