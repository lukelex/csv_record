require_relative '../test_helper'

require 'timecop'

describe CsvRecord::Timestamps do
  describe 'checking if it`s extracting the right fields' do
    it ('checking created_at') { Jedi.fields.must_include :created_at }
  end

  describe 'defines on create' do
    before do
      Timecop.freeze(Time.now.utc)
    end

    after do
      Timecop.return
    end

    it 'sets the time wich the object was created' do
      luke.save
      luke.created_at.must_equal Time.now.utc
    end

    it 'sets the updated time on created' do
      luke.save
      luke.updated_at.must_equal Time.now.utc
    end
  end

  describe 'update on update' do
    it 'sets the updated_at attribute on every save' do
      luke.save
      previous_time = luke.updated_at
      luke.update_attribute :age, '18'
      luke.updated_at.wont_equal previous_time
    end
  end
end