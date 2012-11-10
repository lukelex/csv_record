require 'csv_record'

class JediOrder
  include CsvRecord::Document

  has_many :jedis

  def initialize(params={})
    params.each do |key, value|
      self.public_send("#{key}=", value)
    end
  end

  attr_accessor :rank
end