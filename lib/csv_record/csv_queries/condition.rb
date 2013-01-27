class CsvRecord::Condition
  attr_reader :field, :value

  def initialize(field, value)
    @field = field
    @value = value
  end

  def to_code
    "attributes['#{@field}'] == '#{@value}'"
  end
end