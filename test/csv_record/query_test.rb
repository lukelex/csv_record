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

  describe 'lazy querying' do
    before do
      yoda.save
      qui_gon_jinn.save
    end

    describe 'should trigger the query' do
      it 'when calling the to_a' do
        query.to_a.must_be_instance_of Array
        query.to_a.first.must_be_instance_of Jedi
      end

      it 'when calling the first' do
        query.last.must_be_instance_of Jedi
      end

      it 'when calling the last' do
        query.first.must_be_instance_of Jedi
      end
    end
  end
end