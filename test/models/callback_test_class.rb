class CallbackTestClass
  include CsvRecord::Document

  attr_accessor :sample_field

  attr_accessor :after_initialize_called
  attr_accessor :before_create_called, :after_create_called
  attr_accessor :before_validation_called, :after_validation_called
  attr_accessor :before_update_called, :after_update_called

  after_initialize do |obj|
    obj.after_initialize_called = true
  end

  before_create do |obj|
    obj.before_create_called = true
  end

  after_create do |obj|
    obj.after_create_called = true
  end

  before_validation do |obj|
    obj.before_validation_called = true
  end

  after_validation do |obj|
    obj.after_validation_called = true
  end

  before_update do |obj|
    obj.before_update_called = true
  end

  after_update do |obj|
    obj.after_update_called = true
  end
end