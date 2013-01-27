require_relative '../test_helper'
require_relative '../models/jedi'

describe CsvRecord::Query do
  let (:query) { CsvRecord::Query.new Jedi, age: 37 }

  describe 'checking query initialization' do
    describe 'setting the conditions' do
      it 'checking the amount' do
        query.conditions.length.must_equal 1
      end

      it 'checking the type' do
        query.conditions.first.must_be_instance_of CsvRecord::Condition
      end
    end
  end

  describe '#where' do
    describe 'adding more conditions' do
      let (:second_query) { CsvRecord::Query.new Jedi, age: 852 }

      it 'to one query' do
        query.where name: 'Luke Skywalker'
        query.conditions.length.must_equal 2
      end

      it 'two queries' do
        query.where midi_chlorians: '4k'

        query.conditions.length.must_equal 2
        second_query.conditions.length.must_equal 1
      end
    end
  end
end