# frozen_string_literal: true

class CsvRecord::UniquenessValidation
  attr_accessor :field

  def initialize(field)
    self.field = field
  end

  def run_on(obj)
    condition = {}
    condition[self.field] = obj.public_send field
    records = obj.class.__where__ condition
    if records.any? { |record| record != obj }
      obj.errors.add field
    end
  end
end