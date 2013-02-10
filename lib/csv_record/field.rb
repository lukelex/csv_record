class CsvRecord::Field
  attr_reader :field, :doppelganger

  def initialize(field, doppelganger=nil)
    @field = field
    @doppelganger = doppelganger
  end

  def doppelganger
    @doppelganger || @field
  end

  def to_s
    self.field.to_s
  end
end