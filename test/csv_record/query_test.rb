require_relative '../test_helper'
require_relative '../models/jedi'

describe CsvRecord::Query do
  describe 'checking query initialization' do
    let (:query) { CsvRecord::Query.new Jedi, age: 37 }

    describe 'setting the conditions' do
      it 'checking the amount' do
        query.conditions.length.must_equal 1
      end

      it 'checking the type' do
        query.conditions.first.must_be_instance_of CsvRecord::Condition
      end
    end
  end
end