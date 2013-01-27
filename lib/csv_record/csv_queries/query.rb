require_relative 'condition'

class CsvRecord::Query
  attr_reader :klass, :conditions

  def initialize(klass, conditions)
    @klass = klass

    @conditions = conditions.map do |condition|
      CsvRecord::Condition.new *condition
    end
  end

  def trigger
    klass.open_database_file do |csv|
      rows = search_for csv, self.conditions
      rows.map { |row| klass.build row.to_hash }
    end
  end

protected

  def search_for(csv, params)
    conditions_string = self.conditions_as_string
    csv.entries.select do |attributes|
      eval conditions_string
    end
  end

  def conditions_as_string
    conditions_string = ''
    self.conditions.each_with_index do |condition, index|
      conditions_string << condition.to_s
      conditions_string << ' && ' if first_or_last? index
    end
    conditions_string
  end

  def first_or_last?(index)
    (self.conditions.size > 1) && (index != self.conditions.size - 1)
  end
end