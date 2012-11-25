require_relative '../test_helper'
require 'pry'
require_relative '../models/jedi'
require_relative '../models/jedi_order'

describe CsvRecord::Validations do
  describe 'initializing class methods' do
    it ('responds to validates_presence_of') { Jedi.must_respond_to :validates_presence_of }
    it ('responds to validates_uniqueness_of') { Jedi.must_respond_to :validates_uniqueness_of }
    it ('responds to valid?') { Jedi.new.must_respond_to :valid? }
    it ('responds to invalid?') { Jedi.new.must_respond_to :invalid? }
  end

  describe 'validates_presence_of :name and :age behavior' do
    it 'is not valid without name' do
      yoda.name = nil
      yoda.valid?.wont_equal true
    end

    it 'is not valid without age' do
      yoda.age = nil
      yoda.valid?.wont_equal true
    end

    it "is valid with all attributes filled" do
      yoda.valid?.must_equal true
    end

    it "saves with both attributes filled" do
      yoda.save.must_equal true
    end

    it "doesn't save without name" do
      yoda.name = nil
      yoda.valid?.wont_equal true
      yoda.save.wont_equal true
    end

    it "doesn't save without age" do
      yoda.age = nil
      yoda.valid?.wont_equal true
      yoda.save.wont_equal true
    end

    it "doesn't save without both" do
      yoda.age = nil
      yoda.name = nil
      yoda.valid?.wont_equal true
      yoda.save.wont_equal true
    end
  end

  describe 'default methods' do
    let (:invalid_jedi) { Jedi.new }

    describe 'invalid?' do
      it 'invalid object' do
        invalid_jedi.invalid?.must_equal true
      end

      it 'valid object' do
        yoda.invalid?.must_equal false
      end
    end

    describe 'errors' do
      it 'wont be empty when invalid' do
        invalid_jedi.valid?
        invalid_jedi.errors.wont_be_empty
      end

      it 'should have two erros' do
        invalid_jedi.valid?
        invalid_jedi.errors.length.must_equal 2
      end
    end
  end

  describe 'validates_uniqueness_of' do
    before { yoda.save }

    let :fake_yoda do
      fake_yoda = Jedi.new name: 'Yoda the green', age: 238, midi_chlorians: '1k'
    end

    it 'can`t have the same name' do
      fake_yoda.valid?.must_equal false
    end
  end

  describe 'custom_validator' do
    it ('responds to validate') { Jedi.must_respond_to :validate }

    it 'addin a custom validator' do
      yoda.valid?
      yoda.custom_validator_checker.wont_be_nil
      yoda.custom_validator_checker.must_equal true
    end
  end
end