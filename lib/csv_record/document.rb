require 'active_support/core_ext/string/inflections.rb'

require 'csv_record/connector'
require 'csv_record/writer'
require 'csv_record/reader'
require 'csv_record/timestamps'
require 'csv_record/callbacks'
require 'csv_record/helpers'
require 'csv_record/associations'
require 'csv_record/csv_validations/validations'

require 'csv_record/fields'
require 'csv_record/field'
require 'csv_record/exceptions'

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
