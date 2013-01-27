require_relative 'condition'

class CsvRecord::Query
  attr_reader :conditions, :klass

  def initialize(klass, conditions)
    @conditions = conditions.map do |condition|
      CsvRecord::Condition.new *condition
    end
  end
end