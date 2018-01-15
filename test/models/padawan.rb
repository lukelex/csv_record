class Padawan
  include CsvRecord::Document

  attr_accessor :name, :age, :midi_chlorians

  belongs_to :jedi
end
