require_relative '../test_helper'

require_relative '../models/car'
require_relative '../models/callback_test_class'

describe CsvRecord::Callbacks do
  describe "Check the callback definitions" do
    let (:klass) { CallbackTestClass }

    it ('before_create callback') { klass.must_respond_to(:before_create) }
    it ('after_create callback') { klass.must_respond_to(:after_create) }
    it ('before_save callback') { klass.must_respond_to(:before_save) }
    it ('after_save callback') { klass.must_respond_to(:after_save) }
    it ('after_initialize callback') { klass.must_respond_to(:after_initialize) }
  end

  describe "Check the run callback definitions" do
    let (:klass) { CallbackTestClass.new }

    it ('run before_create callbacks') { klass.must_respond_to(:run_before_create_callbacks) }
    it ('run after_create callbacks') { klass.must_respond_to(:run_after_create_callbacks) }
    it ('run before_validation callbacks') { klass.must_respond_to(:run_before_validation_callbacks) }
    it ('run after_validation callbacks') { klass.must_respond_to(:run_after_validation_callbacks) }
    it ('run before_save callbacks') { klass.must_respond_to(:run_before_save_callbacks) }
    it ('run after_save callbacks') { klass.must_respond_to(:run_after_save_callbacks) }
    it ('run after_initialize callbacks') { klass.must_respond_to(:run_after_initialize_callbacks) }
    it ('run before_update callbacks') { klass.must_respond_to(:run_before_update_callbacks) }
    it ('run after_update callbacks') { klass.must_respond_to(:run_after_update_callbacks) }
  end

  describe 'Checking the callbacks execution' do
    let (:object_created) { CallbackTestClass.create }
    let (:object_updated) do
      object_created.update_attribute :sample_field, 'something'
      object_created
    end

    it 'after_initialize' do
      a = CallbackTestClass.new
      p a
      a.after_initialize_called.must_equal true
    end

    it 'before_create' do
      object_created.before_create_called.must_equal true
    end

    it 'after_create' do
      object_created.after_create_called.must_equal true
    end

    it 'before_validation' do
      object_created.before_validation_called.must_equal true
    end

    it 'after_validation' do
      object_created.after_validation_called.must_equal true
    end

    it 'before_update' do
      object_updated.before_update_called.must_equal true
    end

    it 'after_update' do
      object_updated.after_update_called.must_equal true
    end
  end
end