class Jedi
  include CsvRecord::Document

  attr_accessor :name, :age, :midi_chlorians

  belongs_to :jedi_order

  validates_presence_of :name, :age
  validates_uniqueness_of :name

  def initialize(params={})
    params.each do |key, value|
      self.public_send("#{key}=", value)
    end
  end
end