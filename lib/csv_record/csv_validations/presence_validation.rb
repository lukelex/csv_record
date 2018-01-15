# frozen_string_literal: true

class CsvRecord::PresenceValidation
  attr_accessor :field

  def initialize(field)
    self.field = field
  end

  def run_on(obj)
    return unless obj.public_send(field).nil?

    obj.errors.add field
  end
end
