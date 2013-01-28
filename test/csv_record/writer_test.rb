require_relative '../test_helper'

describe CsvRecord::Writer do
  describe 'initializing class methods' do
    it 'responds to create' do
      Jedi.must_respond_to :create
    end
  end

  describe 'initializing instance methods' do
    it ('responds to save') { luke.must_respond_to :save }
    it ('responds to new_record?') { luke.must_respond_to :new_record? }
    it ('responds to calculate_id') { luke.must_respond_to :calculate_id }
    it ('responds to write_object') { luke.must_respond_to :write_object }
    it ('responds to id') { luke.must_respond_to :id }
    it ('responds to update_attribute') { luke.must_respond_to :update_attribute }
    it ('responds to update_attributes') { luke.must_respond_to :update_attributes }
    it ('responds to destroy') { luke.must_respond_to :destroy }
  end

  describe 'validating the methods behavior' do
    describe 'create' do
      it "Creates more than one registry" do
        luke.save
        yoda.save
        Jedi.all.size.must_equal 2
      end

      it "Creates the object through create method" do
        created_jedi = Jedi.create(
          name: 'Luke Skywalker',
          age: 18,
          midi_chlorians: '12k'
        )
        created_jedi.wont_be_nil
        created_jedi.must_be_instance_of Jedi
        created_jedi.new_record?.must_equal false
      end

      it "Sets the ID of the created object" do
        luke.id.must_be_nil
        luke.save
        luke.id.must_equal 1
        yoda.save
        yoda.id.must_equal 2
      end
    end

    describe 'new_record' do
      it "Checks whether is a new record" do
        luke.new_record?.must_equal true
        luke.save
        luke.new_record?.must_equal false
      end

      it "Checks whether a previously saved record is a new record" do
        luke.save
        Jedi.find(luke).new_record?.must_equal false
      end
    end

    describe 'updates' do
      before do
        luke.save
      end

      it "Updates a single field" do
        luke.update_attribute :age, 24
        Jedi.find(luke).age.must_equal '24'
      end

      it "Updates multiple fields at the same time" do
        luke.update_attributes name: 'lukas', midi_chlorians: '99999k'
        Jedi.find(luke).name.must_equal 'lukas'
        Jedi.find(luke).midi_chlorians.must_equal '99999k'
      end

      it "Updates multiple fields using save" do
        luke.name = 'lukas'
        luke.age = 24
        luke.save
        retrieved_jedi = Jedi.find(luke)
        retrieved_jedi.name.must_equal 'lukas'
        retrieved_jedi.age.must_equal '24'
      end

      it 'should take a block' do
        luke.update_attributes do |jedi|
          jedi.age = 25
          jedi.name = 'Lukas Skywalker'
        end
        luke.age.must_equal 25
        luke.name.must_equal 'Lukas Skywalker'
      end
    end

    describe 'destroy' do
      it 'remove the object from the database' do
        luke.save
        luke.destroy
        Jedi.count.must_equal 0
      end

      it 'by destroying the object its timestamps and id should be empty' do
        luke.save
        luke.destroy
        luke.id.must_be_nil
        luke.created_at.must_be_nil
        luke.updated_at.must_be_nil
      end
    end
  end
end