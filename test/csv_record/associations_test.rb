require_relative '../test_helper'

require_relative '../models/jedi_order'
require_relative '../models/jedi'

describe CsvRecord::Associations do
  describe 'initializing class methods' do
    it ('responds to belongs_to') { Jedi.must_respond_to :belongs_to }
    it ('responds to jedi_order') { Jedi.new.must_respond_to :jedi_order }
    it ('responds to jedi_order=') { Jedi.new.must_respond_to :jedi_order= }
    it ('responds to jedi_order_id') { Jedi.new.must_respond_to :jedi_order_id }
  end

  describe 'validating the methods behavior' do
    it 'checking to param extraction' do
      jedi_council.save
      luke.save
      luke.jedi_order = jedi_council
      luke.jedi_order_id.wont_be_nil
      luke.jedi_order_id.must_be_instance_of Fixnum
      luke.jedi_order_id.must_equal 1
    end

    it 'has a single jedi associated' do
      jedi_council.save
      luke.jedi_order = jedi_council
      luke.save.must_equal true
      first_jedi = Jedi.first
      first_jedi.jedi_order.wont_be_nil
      first_jedi.jedi_order_id.must_be_instance_of Fixnum
      first_jedi.jedi_order.must_be_instance_of JediOrder
    end
  end
end