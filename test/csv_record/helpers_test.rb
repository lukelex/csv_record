require_relative '../test_helper'

describe 'CsvRecord::Helpers' do
  it 'check if a string is an integer' do
    '2000'.integer?.must_equal true
  end

  it 'check if a string is a float' do
    '2000.00'.float?.must_equal true
  end
end