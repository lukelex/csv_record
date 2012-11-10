require_relative '../test_helper'

require_relative '../models/jedi'
require_relative '../models/jedi_order'

describe CsvRecord::Associations do
  describe 'initializing class methods' do
    it ('responds to belongs_to') { Jedi.must_respond_to :belongs_to }
    it ('responds to jedi_order') { Jedi.new.must_respond_to :jedi_order }
    it ('responds to jedi_order=') { Jedi.new.must_respond_to :jedi_order= }
    it ('responds to jedi_order_id') { Jedi.new.must_respond_to :jedi_order_id }
    it ('responds to has_many') { JediOrder.must_respond_to :has_many }
  end

  describe 'belongs_to behavior' do
    it 'checking to param extraction' do
      jedi_council.save
      luke.save
      luke.jedi_order = jedi_council
      luke.jedi_order_id.wont_be_nil
      luke.jedi_order_id.must_be_instance_of Fixnum
      luke.jedi_order_id.must_equal 1
    end

    it 'has a single jedi order associated' do
      jedi_council.save
      luke.jedi_order = jedi_council
      luke.save.must_equal true
      first_jedi = Jedi.first
      first_jedi.jedi_order.wont_be_nil
      first_jedi.jedi_order_id.must_be_instance_of Fixnum
      first_jedi.jedi_order.must_be_instance_of JediOrder
    end
  end

  describe 'has_many behavior' do
    it 'has many jedis associated' do
      jedi_council.save
      yoda.jedi_order = jedi_council
      yoda.save
      Jedi.create name: 'Qui-Gon Jinn', age: 37, midi_chlorians: '3k', jedi_order: jedi_council
      luke.save
      jedis = jedi_council.jedis
      jedis.count.must_equal 2
      jedis.first.must_be_instance_of Jedi
    end
  end
end