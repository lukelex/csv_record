require_relative '../test_helper'

describe CsvRecord::Condition do
  let (:condition) { CsvRecord::Condition.new :age, 37 }

  describe 'checking query initialization' do
    it 'field should be "age"' do
      condition.field.must_equal :age
    end

    it 'value should be "37"' do
      condition.value.must_equal 37
    end
  end

  describe '.create_from_hashes' do
    it 'with one' do
      conditions = CsvRecord::Condition.create_from_hashes age: 37
      conditions.size.must_equal 1
      conditions.first.must_be_instance_of CsvRecord::Condition
    end

    it 'more than one' do
      conditions = CsvRecord::Condition.create_from_hashes age: 37, midi_chlorians: '3k'
      conditions.size.must_equal 2
      conditions.first.must_be_instance_of CsvRecord::Condition
    end
  end

  describe '#to_code' do
    it 'trasforming the field and value' do
      condition.to_code.must_equal "attributes['age'] == '37'"
    end
  end
end