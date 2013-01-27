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

  describe '#to_code' do
    it 'trasforming the field and value' do
      condition.to_code.must_equal "attributes['age'] == '37'"
    end
  end
end