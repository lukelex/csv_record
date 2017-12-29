class CsvRecord::Condition
  attr_reader :field, :value

  def initialize(field, value)
    @field = field
    @value = value
  end

  def self.create_from_hashes(hashes)
    hashes.map do |hash|
      new(*hash)
    end
  end

  def to_code
    "attributes['#{@field}'] == '#{@value}'"
  end
end
