require_relative '../test_helper'

require_relative '../models/jedi'
require_relative '../models/jedi_order'

describe CsvRecord::Validation do

  describe 'initializing class methods' do
    it ('responds to validates_presence_of') { Jedi.must_respond_to :validates_presence_of }
  end

end