require 'csv_record'

class Jedi
  include CsvRecord::Document

  belongs_to :jedi_order

  validates_presence_of :name, :age

  def initialize(params={})
    params.each do |key, value|
      self.public_send("#{key}=", value)
    end
  end

  attr_accessor :name, :age, :midi_chlorians
end