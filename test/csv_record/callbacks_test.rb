require_relative '../test_helper'
require_relative '../models/car'
require_relative '../models/callback_test_class'

describe CsvRecord::Callbacks do
  describe "Check the callback definitions" do
    let (:klass) { CallbackTestClass }

    it ('before_create callback') { klass.must_respond_to(:before_create) }
    it ('after_create callback') { klass.must_respond_to(:after_create) }
    it ('before_save callback') { klass.must_respond_to(:before_save) }
    it ('before_destroy callback') {klass.must_respond_to(:before_destroy)}
    it ('after_save callback') { klass.must_respond_to(:after_save) }
    it ('before_update callback') { klass.must_respond_to(:before_update) }
    it ('after_update callback') { klass.must_respond_to(:after_update) }
    it ('after_initialize callback') { klass.must_respond_to(:after_initialize) }
    it ('after_destroy callback') { klass.must_respond_to(:after_destroy) }
    it ('after_find callback') { klass.must_respond_to(:after_find) }
  end

  describe "Check the run callback definitions" do
    let (:klass) { CallbackTestClass.new }
    it ('run before_create callbacks') { klass.must_respond_to(:run_before_create_callbacks) }
    it ('run after_create callbacks') { klass.must_respond_to(:run_after_create_callbacks) }
    it ('run after_destroy callback') { klass.must_respond_to(:run_after_destroy_callbacks) }
    it ('run before_validation callbacks') { klass.must_respond_to(:run_before_validation_callbacks) }
    it ('run after_validation callbacks') { klass.must_respond_to(:run_after_validation_callbacks) }
    it ('run before_save callbacks') { klass.must_respond_to(:run_before_save_callbacks) }
    it ('run after_save callbacks') { klass.must_respond_to(:run_after_save_callbacks) }
    it ('run after_initialize callbacks') { klass.must_respond_to(:run_after_initialize_callbacks) }
    it ('run before_update callbacks') { klass.must_respond_to(:run_before_update_callbacks) }
    it ('run after_update callbacks') { klass.must_respond_to(:run_after_update_callbacks) }
    it ('run before_destroy callbacks ') { klass.must_respond_to(:run_before_destroy_callbacks) }
    it ('run after_find callbacks') { klass.must_respond_to(:run_after_find_callbacks) }
  end

  describe 'Checking the callbacks execution' do
    let (:object_created) { CallbackTestClass.create }
    let (:object_updated) do
      object_created.update_attribute :sample_field, 'something'
      object_created
    end

    let (:object_destroyed) do
      object_created.destroy
      object_created
    end

    it 'after_initialize' do
      CallbackTestClass.new.after_initialize_called.must_equal true
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

    it 'before_save' do
      object_created.before_save_called.must_equal true
    end

    it 'after_update' do
      object_created.after_save_called.must_equal true
    end

    it 'after_destroy' do
      object_destroyed.after_destroy_called.must_equal true
    end
    it 'before_destroy' do
      object_destroyed.before_destroy_called.must_equal true
    end

    it 'after_find using FIND' do
      object_found = CallbackTestClass.find(object_created)
      object_found.after_find_called.must_equal true
    end
  end
end