require_relative '../test_helper'
require 'pry'
require_relative '../models/jedi'
require_relative '../models/jedi_order'

describe CsvRecord::Validations do
  describe 'initializing class methods' do
    it ('responds to validates_presence_of') { Jedi.must_respond_to :validates_presence_of }
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
end