class CsvRecord::Field
  attr_reader :name, :doppelganger

  def initialize(name, doppelganger=nil)
    @name = name
    @doppelganger = doppelganger
  end

  def doppelganger
    @doppelganger || @name
  end

  def to_s
    self.name.to_s
  end

  def is?(value)
    self.doppelganger.to_sym == value.to_sym ||
      self.name.to_sym == value.to_sym
  end
end