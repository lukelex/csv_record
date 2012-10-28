class CallbackTestClass
  include CsvRecord::Document

  def initialize(*args)
  end

  attr_accessor :before_create_called, :after_create_called

  before_create do |obj|
    obj.before_create_called = true
  end

  after_create do |obj|
    obj.after_create_called = true
  end
end