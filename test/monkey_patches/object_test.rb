require_relative '../test_helper'

describe Object do
  describe 'monkey patch' do
    it ('responds to integer?') { Object.new.must_respond_to :integer? }
    it ('responds to float?') { Object.new.must_respond_to :float? }
    it ('responds to to_param?') { Object.new.must_respond_to :to_param }
  end

  describe 'integer?' do
    it 'passing an integer' do
      15.integer?.must_equal true
    end

    it 'passing a string' do
      'abc'.integer?.must_equal false
    end
  end

  describe 'float?' do
    it 'passing a float' do
      (15.50).float?.must_equal true
    end

    it 'passing an integer' do
      15.float?.must_equal false
    end

    it 'passing a string' do
      'abc'.float?.must_equal false
    end
  end

  describe 'to_param?' do
    it 'in an integer' do
      15.to_param.must_equal 15
    end

    it 'passing a string' do
      'abc'.to_param.must_equal 'abc'
    end

    it 'passing a string' do
      (15.50).to_param.must_equal 15.50
    end
  end
end