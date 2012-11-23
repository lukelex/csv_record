require_relative '../test_helper'

describe Array do
  describe 'add' do
    it ('responds to add') { Object.new.must_respond_to :integer? }

    it 'adding' do
      arr = Array.new
      arr.add(:testing)
      arr.wont_be_empty
      arr.last.must_equal :testing
    end
  end
end