# frozen_string_literal: true

require_relative 'condition'

class CsvRecord::Query
  include Enumerable

  attr_reader :klass, :conditions

  def initialize(klass, conditions)
    @klass = klass

    @conditions = conditions.map do |condition|
      CsvRecord::Condition.new(*condition)
    end
  end

  def __where__(params)
    new_conditions = (CsvRecord::Condition.create_from_hashes params)
    @conditions = (@conditions << new_conditions).flatten # figure out a way to solve this later
    self
  end

  def __trigger__
    klass.open_database_file do |csv|
      rows = search_for csv, conditions
      rows.map { |row| klass.build row.to_hash }
    end
  end

  def inspect
    to_a.inspect
  end

  def __to_a__
    trigger
  end

  def last
    to_a.last
  end

  def each(&block)
    to_a.each(&block)
  end

  def empty?
    to_a.empty?
  end

  alias :where :__where__
  alias :trigger :__trigger__
  alias :to_a :__to_a__

  private

  def search_for(csv, params)
    csv.entries.select do |attributes|
      eval conditions_as_string
    end
  end

  def conditions_as_string
    @_conditions_as_string ||= conditions.map(&:to_code).join ' and '
  end
end
