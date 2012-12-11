class CallbackTestClass
  include CsvRecord::Document

  attr_accessor :sample_field

  attr_accessor :after_initialize_called
  attr_accessor :before_create_called, :after_create_called
  attr_accessor :before_validation_called, :after_validation_called
  attr_accessor :before_update_called, :after_update_called
  attr_accessor :before_save_called, :after_save_called
  attr_accessor :before_destroy_called, :after_destroy_called
  attr_accessor :after_find_called, :after_where_called

  after_initialize do
    self.after_initialize_called = true
  end

  after_find do
    self.after_find_called = true
  end

  before_create do
    self.before_create_called = true
  end

  after_create do
    self.after_create_called = true
  end

  before_validation do
    self.before_validation_called = true
  end

  after_validation do
    self.after_validation_called = true
  end

  before_update do
    self.before_update_called = true
  end

  after_update do
    self.after_update_called = true
  end

  before_save do
    self.before_save_called = true
  end

  after_save do
    self.after_save_called = true
  end

  after_destroy do
    self.after_destroy_called = true
  end

  before_destroy do
    self.before_destroy_called = true
  end

end