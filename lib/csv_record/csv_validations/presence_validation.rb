class CsvRecord::PresenceValidation
  attr_accessor :field

  def initialize(field)
    self.field = field
  end

  def run_on(obj)
    if obj.public_send(self.field).nil?
      obj.errors.add self.field
    end
  end
end