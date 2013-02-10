require_relative '../test_helper'

describe CsvRecord::Associations do
  describe 'belongs_to' do
    it ('responds to belongs_to') { Jedi.must_respond_to :belongs_to }

    it ('responds to jedi_order') { Jedi.new.must_respond_to :jedi_order }
    it ('responds to jedi_order=') { Jedi.new.must_respond_to :jedi_order= }
    it ('responds to jedi_order_id') { Jedi.new.must_respond_to :jedi_order_id }

    before do
      jedi_council.save
    end

    it 'checking to param extraction' do
      luke.save
      luke.jedi_order = jedi_council
      luke.jedi_order_id.wont_be_nil
      luke.jedi_order_id.must_be_instance_of Fixnum
      luke.jedi_order_id.must_equal 1
    end

    it 'has a single jedi order associated' do
      luke.jedi_order = jedi_council
      luke.save.must_equal true
      first_jedi = Jedi.first
      first_jedi.jedi_order.wont_be_nil
      first_jedi.jedi_order_id.must_be_instance_of Fixnum
      first_jedi.jedi_order.must_be_instance_of JediOrder
    end
  end

  describe 'has_many' do
    it ('responds to has_many') { JediOrder.must_respond_to :has_many }

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

  describe 'has_one' do
    it ('responds to has_one') { Jedi.must_respond_to :has_one }

    it 'has_one padawan' do
      qui_gon_jinn.save
      obi_wan_kenobi_padawan.save
      qui_gon_jinn.padawan = obi_wan_kenobi_padawan
      qui_gon_jinn.padawan.must_equal obi_wan_kenobi_padawan
      qui_gon_jinn.padawan.must_be_instance_of Padawan
    end
  end
end