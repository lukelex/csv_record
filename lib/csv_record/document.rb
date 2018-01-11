require 'active_support/core_ext/string/inflections.rb'

require_relative 'connector'
require_relative 'writer'
require_relative 'reader'
require_relative 'timestamps'
require_relative 'callbacks'
require_relative 'helpers'
require_relative 'associations'
require_relative 'csv_validations/validations'

require_relative 'fields'
require_relative 'field'
require_relative 'exceptions'

# This is the base module for all domain objects that need to be persisted to
# the database.
module CsvRecord::Document
  def self.included(receiver)
    receiver.extend         CsvRecord::Connector
    receiver.extend         CsvRecord::Associations
    receiver.extend         CsvRecord::Validations::ClassMethods
    receiver.send :include, CsvRecord::Reader
    receiver.send :include, CsvRecord::Writer
    receiver.send :include, CsvRecord::Validations::InstanceMethods
    receiver.send :include, CsvRecord::Callbacks
    receiver.send :include, CsvRecord::Timestamps

    receiver.store_as receiver.name
  end
end
