require_relative '../test_helper'

require_relative '../models/jedi'
require_relative '../models/jedi_order'

describe CsvRecord::Validation do

  describe 'initializing class methods' do
    it ('responds to validates_presence_of') { Jedi.must_respond_to :validates_presence_of }
  end

  describe 'validates_presence_of :name behavior' do

    it 'is not valid without name' do
      yoda.name = nil
      yoda.valid?.wont_equal true
    end

  end

end